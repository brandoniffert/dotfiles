-- Ensure HTML indenter is available
if vim.fn.exists("*GetHTMLIndent") == 0 and vim.fn.exists("*HtmlIndent") == 0 then
  vim.cmd("runtime! indent/html.vim")
end

-- Keep TS indent from fighting us (if installed)
if vim.fn.exists(":TSBufDisable") == 2 then
  vim.cmd("silent! TSBufDisable indent")
end

-- Silverstripe block regexes
local rx_begin = vim.regex([[<%\s\%(if\|with\|loop\|cached\)\>]])
local rx_branch = vim.regex([[<%\s\%(else\|else_if\)\>]])
local rx_end = vim.regex([[<%\s\%(end_if\|end_with\|end_loop\|end_cached\)\>]])

local void_tags = {
  area = true,
  base = true,
  br = true,
  col = true,
  embed = true,
  hr = true,
  img = true,
  input = true,
  link = true,
  meta = true,
  param = true,
  source = true,
  track = true,
  wbr = true,
}

local function prev_nonblank(lnum)
  local pl = vim.fn.prevnonblank(lnum - 1)
  return pl > 0 and pl or 0
end

local function is_sst_begin(s)
  return rx_begin:match_str(s) ~= nil
end
local function is_sst_branch(s)
  return rx_branch:match_str(s) ~= nil
end
local function is_sst_end(s)
  return rx_end:match_str(s) ~= nil
end

-- HEAD info of a tag (up to first '>'): tagname, self_closing, inline_close, has_directive_in_head
local function head_info(line)
  local l = line:match("^%s*(.*)$") or ""
  local gt = l:find(">", 1, true)
  if not gt then
    return nil, false, false, false
  end
  local head = l:sub(1, gt)
  local tag = head:match("^<([%a][%w:-]*)%f[%W]")
  if not tag then
    return nil, false, false, false
  end
  local self_closing = head:match("/>%s*$") ~= nil
  local has_directive = head:find("<%%", 1, true) ~= nil
  local tail = l:sub(gt + 1)
  local inline_close = tail:find("</%s*" .. tag .. "%s*>") ~= nil
  return tag, self_closing, inline_close, has_directive
end

local function is_open_tag(line)
  if line:match("^%s*</") then
    return false
  end
  local tag, self_closing, inline_close = head_info(line)
  if not tag then
    return false
  end
  if void_tags[tag:lower()] then
    return false
  end
  if self_closing or inline_close then
    return false
  end
  return true
end

local function is_mixed_open_tag(line)
  local tag, self_closing, inline_close, has_dir = head_info(line)
  if not tag then
    return false
  end
  if void_tags[tag:lower()] then
    return false
  end
  if self_closing or inline_close then
    return false
  end
  return has_dir
end

_G.SSIndent = function()
  local sw = vim.fn.shiftwidth()
  if sw == 0 then
    sw = vim.fn.tabstop()
  end -- guard against shiftwidth=0
  local ln = vim.v.lnum
  local pl = prev_nonblank(ln)
  if pl == 0 then
    return 0
  end

  local cur = vim.fn.getline(ln)
  local prev = vim.fn.getline(pl)
  local pind = vim.fn.indent(pl)

  -- Base HTML indent
  local html = 0
  if vim.fn.exists("*GetHTMLIndent") == 1 then
    html = vim.fn.GetHTMLIndent()
  elseif vim.fn.exists("*HtmlIndent") == 1 then
    html = vim.fn.HtmlIndent()
  end

  -- Silverstripe control flow
  if is_sst_end(cur) or is_sst_branch(cur) then
    return is_sst_begin(prev) and pind or math.max(0, pind - sw)
  end
  if is_sst_begin(prev) then
    return pind + sw
  end

  -- Core structural rules
  -- 1) If PREVIOUS line is an opening HTML tag (even if it embeds <% ... %>), force child indent
  if is_open_tag(prev) or is_mixed_open_tag(prev) then
    return pind + sw
  end

  -- 2) If CURRENT line is an opening tag with <% ... %> in its head, keep it under the parent
  if is_mixed_open_tag(cur) then
    return pind + sw
  end

  -- Default: HTML's indent
  return html
end

vim.bo.indentexpr = "v:lua.SSIndent()"
vim.bo.indentkeys = "o,O,*<Return>,<:>,0),0],0},=end_if,=end_with,=end_loop,=end_cached,=else,=else_if"
