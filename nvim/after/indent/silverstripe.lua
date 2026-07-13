-- SilverStripe indent: regex-free tree-sitter shim over nvim-treesitter's
-- html-injection base indent.
--
-- Why a shim (see queries/indents.scm header in tree-sitter-silverstripe):
-- nvim-treesitter `main` picks ONE tree per line -- the smallest root spanning
-- (lnum-1, col 0) across the host + injected trees -- and the combined `html`
-- injection over (content) spans nearly the whole file, so it wins for almost
-- every line. indents.scm therefore never drives nvim indent for SS-block depth.
-- Final indent = nvim-treesitter's base (html part) + shiftwidth * SS-block-depth
-- computed from the buffer's HOST silverstripe tree.

local ts = vim.treesitter
local nti = require("nvim-treesitter.indent")

-- Mirror nvim-treesitter/indent.lua M.comment_parsers (indent.lua:5-11) so the
-- selected-tree replication below skips comment sub-parsers exactly as it does.
local COMMENT_PARSERS = {
  comment = true,
  luadoc = true,
  javadoc = true,
  jsdoc = true,
  phpdoc = true,
}

-- Node-type sets, single-sourced from the parser's own queries/indents.scm.
-- A compiled vim.treesitter.Query exposes capture *names* and predicate
-- metadata but NOT the node types each capture matches, so we read the query
-- file text (via query.get_files) and bucket `(node_type)` s-exprs by the
-- @indent.* capture that terminates each pattern. Cached per session; falls
-- back to the hardcoded sets below (kept in sync with indents.scm) if the file
-- can't be read/parsed.
local SETS

local FALLBACK = {
  stmt = { -- @indent.begin *_statement types: each adds a block depth level
    if_statement = true,
    loop_statement = true,
    with_statement = true,
    cached_statement = true,
    uncached_statement = true,
  },
  open = { -- @indent.begin *_tag openers: used for typing-time recovery
    if_tag = true,
    loop_tag = true,
    with_tag = true,
    cached_tag = true,
    uncached_tag = true,
  },
  branch = { -- @indent.branch tags: dedent their own line one level
    else_tag = true,
    else_if_tag = true,
    end_if_tag = true,
    end_loop_tag = true,
    end_with_tag = true,
    end_cached_tag = true,
  },
}

local function build_sets()
  local files = ts.query.get_files("silverstripe", "indents")
  local path = files and files[1]
  local lines
  if path then
    local ok, data = pcall(vim.fn.readfile, path)
    if ok then
      lines = data
    end
  end
  if not lines then
    return FALLBACK
  end

  local sets = { stmt = {}, open = {}, branch = {} }
  local pending = {} -- node types seen since the last capture (bracket list spans lines)
  for _, raw in ipairs(lines) do
    local code = raw:gsub(";.*", "") -- strip `;` line comments
    for name in code:gmatch("%(%s*([%a_][%w_]*)") do -- `(node_type ...`; skips `(#pred` and strings
      pending[#pending + 1] = name
    end
    local cap = code:match("@indent%.(%a+)")
    if cap then
      if cap == "begin" then
        for _, n in ipairs(pending) do
          if n:match("_statement$") then
            sets.stmt[n] = true
          elseif n:match("_tag$") then
            sets.open[n] = true
          end
        end
      elseif cap == "branch" then
        for _, n in ipairs(pending) do
          sets.branch[n] = true
        end
      end
      -- @indent.end / @indent.auto etc.: drop pending (those node types are
      -- already bucketed by their earlier @indent.branch pattern)
      pending = {}
    end
  end

  if next(sets.stmt) and next(sets.open) and next(sets.branch) then
    return sets
  end
  return FALLBACK
end

local function sets()
  if not SETS then
    SETS = build_sets()
  end
  return SETS
end

-- Replicates indent.lua:123-134: the selected tree is the one with the SMALLEST
-- byte length whose root contains (lnum-1, col 0), skipping comment sub-parsers.
-- Returns (host_selected, selected_root). If the host silverstripe tree is
-- selected, indents.scm already computed SS depth for this line, so we must NOT
-- add it again. Otherwise `selected_root` is the injected root that indent.lua
-- anchored its base indent to (see indent.lua:171-175).
local function select_tree(parser, lnum)
  local sel_root, sel_tree
  parser:for_each_tree(function(tstree, tree)
    if not tstree or COMMENT_PARSERS[tree:lang()] then
      return
    end
    local r = tstree:root()
    if ts.is_in_node_range(r, lnum - 1, 0) then
      if not sel_root or sel_root:byte_length() >= r:byte_length() then
        sel_root, sel_tree = r, tree
      end
    end
  end)
  return (sel_tree ~= nil and sel_tree:lang() == "silverstripe"), sel_root
end

-- SS block depth of content on `lnum`, computed on the HOST silverstripe tree:
-- +1 per enclosing block statement opened on an earlier row (rule 2), -1 if the
-- line's first node climbs to a branch tag starting on this row (rule 3).
local function ss_depth(root, lnum)
  local S = sets()
  -- first node at (lnum-1, first-nonblank col); col 0 on blank lines.
  local line = vim.fn.getline(lnum)
  local col = line:match("^%s*$") and 0 or #(line:match("^%s*"))
  local node = root:descendant_for_range(lnum - 1, col, lnum - 1, col + 1)
  if not node then
    return 0
  end

  local depth = 0
  local n = node
  while n do
    if S.branch[n:type()] and n:start() == lnum - 1 then
      depth = depth - 1
      break
    end
    n = n:parent()
  end
  n = node
  while n do
    if S.stmt[n:type()] and n:start() < lnum - 1 then
      depth = depth + 1
    end
    n = n:parent()
  end
  return depth
end

-- Rule 4, typing-time recovery: if the previous non-blank line ends inside an
-- UNPAIRED opener (opener tag whose parent is ERROR -- no wrapping *_statement
-- exists yet), indent one level in. Makes `o` after typing `<% if $x %>` indent
-- before the matching end_if is written.
local function ss_recovery(root, lnum)
  local S = sets()
  local pl = vim.fn.prevnonblank(lnum - 1)
  if pl <= 0 then
    return 0
  end
  local pline = vim.fn.getline(pl):gsub("%s+$", "")
  local pcol = #pline - 1
  if pcol < 0 then
    return 0
  end
  local node = root:descendant_for_range(pl - 1, pcol, pl - 1, pcol + 1)
  local m = node
  while m do
    if S.open[m:type()] then
      local parent = m:parent()
      return (parent and parent:type() == "ERROR") and 1 or 0
    end
    m = m:parent()
  end
  return 0
end

function _G.SSTSIndent()
  local lnum = vim.v.lnum
  local base = nti.get_indent(lnum) -- html-injection base (indent.lua get_indent)
  if base < 0 then
    return base -- -1 == "keep current"; pass through
  end

  local ok, parser = pcall(ts.get_parser, 0, "silverstripe")
  if not ok or not parser then
    return base
  end

  local host_sel, sel_root = select_tree(parser, lnum)
  if host_sel then
    return base -- host tree selected: indents.scm already answered fully
  end

  local host = parser:parse({ lnum - 1, lnum })[1]
  if not host then
    return base
  end
  local root = host:root()

  local sw = vim.fn.shiftwidth()
  if sw == 0 then
    sw = vim.fn.tabstop()
  end

  local depth = ss_depth(root, lnum) + ss_recovery(root, lnum)

  -- indent.lua anchors the html base to the indent of `sel_root:start()`'s line
  -- (indent.lua:171-175). Two cases:
  --  * anchor line is ABOVE lnum: it is already settled and its buffer indent
  --    bakes in ITS own SS depth, so subtract that to avoid double-counting SS
  --    depth on else/end lines when the injection starts inside a block.
  --  * anchor line IS lnum (the injection's first content line sits on the line
  --    we're indenting): base == indent(lnum) is circular/stale, and lnum's html
  --    nesting within the fragment is 0, so the SS depth alone is the answer.
  local arow = sel_root and sel_root:start() or nil
  if arow == nil then
    return base + depth * sw
  elseif arow == lnum - 1 then
    return depth * sw
  end
  return base + (depth - ss_depth(root, arow + 1)) * sw
end

vim.bo.indentexpr = "v:lua.SSTSIndent()"
-- Keep the old triggers; add the shared uncached/cacheblock closers.
vim.bo.indentkeys = "o,O,*<Return>,<>>,0),0],0},"
  .. "=end_if,=end_with,=end_loop,=end_cached,=end_uncached,=end_cacheblock,=else,=else_if"
