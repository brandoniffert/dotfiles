-- Load nvim-lspconfig's base config at runtime instead of duplicating it.
-- vim.lsp.config merges runtime lsp/ configs with tbl_deep_extend, which REPLACES
-- list-like values (filetypes, classAttributes) rather than appending, so this file
-- must return the full extended lists.
local base = {}
for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/tailwindcss.lua", true)) do
  -- Skip after/ matches (including this file) to avoid recursion.
  if not path:match("/after/") then
    base = dofile(path)
    break
  end
end

base.filetypes = base.filetypes or {}
table.insert(base.filetypes, "silverstripe")

base.settings = base.settings or {}
base.settings.tailwindCSS = base.settings.tailwindCSS or {}

local tw = base.settings.tailwindCSS
tw.classAttributes = tw.classAttributes or {}
for _, attr in ipairs({ "Class", "Classes", "ExtraClass", "ExtraClasses" }) do
  table.insert(tw.classAttributes, attr)
end

tw.includeLanguages = tw.includeLanguages or {}
tw.includeLanguages.silverstripe = "html"

---@type vim.lsp.Config
return {
  filetypes = base.filetypes,
  settings = base.settings,
}
