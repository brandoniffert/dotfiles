if vim.fn.exists(":packadd") == 2 then
  vim.cmd("packadd! matchit")
else
  vim.cmd("silent! runtime! macros/matchit.vim")
end

vim.cmd("silent! runtime! ftplugin/html.vim")

-- Helpers
local function literal_gsub(s, what, with)
  local patt = vim.pesc(what)
  local repl = with:gsub("%%", "%%%%")
  return (s:gsub(patt, repl))
end

-- Silverstripe block pairs (IF has "middle")
local ss_if = [[\c<%\s*if.\{-}%>:\c<%\s*\(else\|else_if.\{-}\)\s*%>:\c<%\s*end_if\s*%>]]
local ss_with = [[\c<%\s*with.\{-}%>:\c<%\s*end_with\s*%>]]
local ss_loop = [[\c<%\s*loop.\{-}%>:\c<%\s*end_loop\s*%>]]
local ss_cached = [[\c<%\s*cached.\{-}%>:\c<%\s*end_cached\s*%>]]
local ss_pairs = table.concat({ ss_if, ss_with, ss_loop, ss_cached }, ",")

-- Patch/prepare b:match_words
do
  local mw = type(vim.b.match_words) == "string" and vim.b.match_words or ""

  -- 1) PREPEND Silverstripe pairs so they win on '<% ... %>'
  if not mw:find("<%%\\s*if") then
    mw = ss_pairs .. (mw ~= "" and ("," .. mw) or "")
  end

  -- 2) Patch the generic HTML rule to IGNORE '<%' (avoid treating '%' as a tag)
  local html_generic = [[<\@<=\([^/!][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>]]
  local html_generic_fix = [[<\@<=\([^/!%][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>]]
  mw = literal_gsub(mw, html_generic, html_generic_fix)

  -- 3) Remove UL/LI and DL/DT|DD "middle" triples so % on <ul>/<dl> goes to closing tag
  local ul_triple = [[<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>]]
  local dl_triple = [[<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>]]
  mw = literal_gsub(mw, ul_triple .. ",", "")
  mw = literal_gsub(mw, "," .. ul_triple, "")
  mw = literal_gsub(mw, ul_triple, "")
  mw = literal_gsub(mw, dl_triple .. ",", "")
  mw = literal_gsub(mw, "," .. dl_triple, "")
  mw = literal_gsub(mw, dl_triple, "")

  vim.b.match_words = mw
  vim.b.match_ignorecase = 1
  vim.b.match_skip = vim.b.match_skip or "s:comment\\|string"
end

-- Mapping: if cursor is on '<', move right one char then invoke matchit
-- (prevents built-in angle bracket behavior from intercepting)
vim.keymap.set("n", "%", function()
  local col = vim.fn.col(".")
  local ch = vim.fn.getline("."):sub(col, col)
  if ch == "<" then
    vim.cmd("normal! l")
  end
  vim.fn["matchit#Match_wrapper"](0, 1, "n")
end, { buffer = true, silent = true })
