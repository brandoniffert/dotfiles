--- SmartPick: unified buffer + file picker built on mini.pick.
--- Buffers (by recency) appear above files (alphabetically).
--- Buffer rows get a background highlight; directory portions are dimmed.

local SmartPick = {}
local H = {}

-- ============================================================================
-- PUBLIC API
-- ============================================================================

function SmartPick.setup()
  H.ns_id = vim.api.nvim_create_namespace("SmartPick")

  local set_hl = vim.api.nvim_set_hl
  set_hl(0, "SmartPickBuffer", { default = true, link = "CursorLine" })
  set_hl(0, "SmartPickPath", { default = true, link = "Comment" })
end

function SmartPick.picker()
  if not H.ns_id then
    SmartPick.setup()
  end

  if _G.MiniPick == nil then
    _G.MiniPick = require("mini.pick")
  end

  local buffer_set = {}

  MiniPick.builtin.cli({
    command = {
      "sh",
      "-c",
      "rg --files --hidden --glob '!.git'; rg --files --no-ignore-vcs --hidden --glob '*.env' --glob '!.git' --max-depth 3",
    },
    postprocess = function(paths)
      return H.postprocess(paths, buffer_set)
    end,
  }, {
    source = {
      name = "Smart Open",
      match = function(stritems, inds, query)
        return H.match(stritems, inds, query, buffer_set)
      end,
      show = function(buf_id, items, query)
        H.show(buf_id, items, query, buffer_set)
      end,
      choose = MiniPick.default_choose,
    },
  })
end

-- ============================================================================
-- SECTION: Buffer Management
-- ============================================================================

function H.get_recent_buffers()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  buffers = vim.tbl_filter(function(buf)
    local buftype = vim.bo[buf.bufnr].buftype

    if buftype == "quickfix" or buftype == "prompt" then
      return false
    end

    if buftype == "" then
      if buf.name == "" then
        return false
      end
      return vim.fn.filereadable(buf.name) == 1
    else
      return true
    end
  end, buffers)

  table.sort(buffers, function(a, b)
    return a.lastused > b.lastused
  end)

  return vim.tbl_map(function(buf)
    local buftype = vim.bo[buf.bufnr].buftype
    local is_file = buftype == ""
    local text = is_file and vim.fn.fnamemodify(buf.name, ":.") or buf.name
    return { text = text, bufnr = buf.bufnr, type = "buffer", is_file = is_file }
  end, buffers)
end

-- ============================================================================
-- SECTION: File Operations
-- ============================================================================

function H.deduplicate_files(buffers, files)
  local seen = {}
  for _, buf in ipairs(buffers) do
    seen[buf.text] = true
  end

  local deduplicated = {}
  for _, path in ipairs(files) do
    if path ~= "" then
      path = vim.fn.fnamemodify(path, ":.")
      if not seen[path] then
        table.insert(deduplicated, path)
        seen[path] = true
      end
    end
  end

  table.sort(deduplicated)
  return deduplicated
end

-- ============================================================================
-- SECTION: Item Processing
-- ============================================================================

function H.postprocess(paths, buffer_set)
  local buffers = H.get_recent_buffers()
  local files = H.deduplicate_files(buffers, paths)

  local all_items = {}

  for _, buf in ipairs(buffers) do
    buffer_set[buf.text:lower()] = true
    table.insert(all_items, buf)
  end

  for _, file in ipairs(files) do
    table.insert(all_items, file)
  end

  return all_items
end

-- ============================================================================
-- SECTION: Matching
-- ============================================================================

function H.match(stritems, inds, query, buffer_set)
  if #stritems == 0 or #inds == 0 then
    return inds
  end

  if not query or #query == 0 then
    return MiniPick.default_match(stritems, inds, query, { sync = true })
  end

  local query_str = table.concat(query)

  -- Special query modes or grouped queries: fall back to default_match (no boosting)
  if query_str:find("^[*']") or query_str:find("[%^%$]") or query_str:find("%s") then
    return MiniPick.default_match(stritems, inds, query, { sync = true })
  end

  -- Collect texts for the active indices
  local texts = {}
  local idx_for_pos = {}
  for _, idx in ipairs(inds) do
    texts[#texts + 1] = stritems[idx]
    idx_for_pos[#texts] = idx
  end

  -- Fuzzy match + score
  local result = vim.fn.matchfuzzypos(texts, query_str)
  local matched = result[1]
  local scores = result[3]

  if #matched == 0 then
    return {}
  end

  -- Batch filename matching for filename boost
  local filenames = {}
  for _, text in ipairs(matched) do
    filenames[#filenames + 1] = text:match("([^/]+)$") or text
  end
  local fn_match_set = {}
  for _, fn in ipairs(vim.fn.matchfuzzypos(filenames, query_str)[1]) do
    fn_match_set[fn] = true
  end

  -- Map matched texts back to original indices, apply boosts
  local text_to_indices = {}
  for pos, text in ipairs(texts) do
    if not text_to_indices[text] then
      text_to_indices[text] = {}
    end
    text_to_indices[text][#text_to_indices[text] + 1] = idx_for_pos[pos]
  end

  local scored = {}
  for i, text in ipairs(matched) do
    local indices = text_to_indices[text]
    local idx = indices and table.remove(indices, 1)
    if idx then
      local score = scores[i]
      if buffer_set[text:lower()] then score = score * 2 end
      if fn_match_set[filenames[i]] then score = score * 3 end
      scored[#scored + 1] = { idx = idx, score = score }
    end
  end

  table.sort(scored, function(a, b)
    if a.score == b.score then return a.idx < b.idx end
    return a.score > b.score
  end)

  return vim.tbl_map(function(s) return s.idx end, scored)
end

-- ============================================================================
-- SECTION: Display
-- ============================================================================

function H.show(buf_id, items, query, buffer_set)
  MiniPick.default_show(buf_id, items, query, { show_icons = true })
  vim.api.nvim_buf_clear_namespace(buf_id, H.ns_id, 0, -1)

  for i, item in ipairs(items) do
    local text = type(item) == "table" and item.text or item
    local line_nr = i - 1
    local line = vim.api.nvim_buf_get_lines(buf_id, line_nr, line_nr + 1, false)[1] or ""

    if buffer_set[text:lower()] then
      vim.api.nvim_buf_set_extmark(buf_id, H.ns_id, line_nr, 0, {
        end_col = #line,
        hl_group = "SmartPickBuffer",
        priority = 10,
      })
    end

    local last_slash = text:match(".*()/")
    if last_slash and last_slash > 1 then
      local text_start = line:find(text, 1, true)
      if text_start then
        vim.api.nvim_buf_set_extmark(buf_id, H.ns_id, line_nr, text_start - 1, {
          end_col = text_start - 1 + last_slash - 1,
          hl_group = "SmartPickPath",
          priority = 50,
        })
      end
    end
  end
end

return SmartPick
