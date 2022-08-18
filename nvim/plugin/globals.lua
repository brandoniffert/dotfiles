vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

-- Disable unused providers
local disabled_providers = {
  "node",
  "perl",
  "python",
  "python3",
  "ruby",
}

for _, provider in pairs(disabled_providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Disable built-ins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwFileHandlers",
  "netrwPlugin",
  "netrwSettings",
  "rrhelper",
  "tar",
  "tarPlugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- https://github.com/nathom/filetype.nvim#usage
vim.g.did_load_filetypes = 1
