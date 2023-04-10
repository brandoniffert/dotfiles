local root = vim.env.USER == "root"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.editorconfig = false

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

vim.opt.autoindent = true
vim.opt.backspace = "indent,start,eol"
vim.opt.backup = false
vim.opt.backupcopy = "yes"
vim.opt.belloff = "all"
if vim.env.TMUX ~= nil then
  vim.opt.cmdheight = 2
end
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.cursorline = true
vim.opt.diffopt:append("foldcolumn:0")
vim.opt.emoji = false
vim.opt.expandtab = true
vim.opt.fillchars:append({
  eob = " ",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})
vim.opt.foldenable = false
vim.opt.formatoptions:append("1rnq")
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
end
vim.opt.grepformat = "%f:%l:%m"
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.linebreak = false
vim.opt.list = true
vim.opt.listchars = {
  nbsp = "⦸",
  extends = "»",
  precedes = "«",
  tab = "▷⋯",
  trail = "•",
}
vim.opt.modelines = 5
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 3
vim.opt.showmode = false

if root then
  vim.opt.shada = ""
  vim.opt.shadafile = "NONE"
end

vim.opt.shiftround = false
vim.opt.shiftwidth = 2
vim.opt.shortmess = "AFOSTWacot"
vim.opt.showbreak = "↳ "
vim.opt.showcmd = false
vim.opt.showmatch = true
vim.opt.sidescroll = 0
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.softtabstop = -1
vim.opt.spellcapcheck = ""

local spell_path = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

if vim.fn.filereadable(spell_path) == 1 then
  vim.opt.spellfile = spell_path
end

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = "usetab"
vim.opt.synmaxcol = 200
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500

if root then
  vim.opt.undofile = false
else
  vim.opt.undofile = true
end

vim.opt.updatetime = 2000
vim.opt.updatecount = 0
vim.opt.virtualedit = "block"
vim.opt.visualbell = true
vim.opt.whichwrap = "b,h,l,s,<,>,[,],~"
vim.opt.wildcharm = 26
vim.opt.wildignore:append("*.jpg,*.jpeg,*.png,*.gif,*.sw?,*.pyc,*.so,*.DS_Store*/tmp/*")
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.writebackup = false
