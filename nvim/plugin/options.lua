local root = vim.env.USER == "root"

vim.opt.autoindent = true
vim.opt.backspace = "indent,start,eol"
vim.opt.backup = false
vim.opt.backupcopy = "yes"
vim.opt.belloff = "all"
vim.opt.completeopt = "menuone,noselect"
vim.opt.diffopt:append("foldcolumn:0")
vim.opt.emoji = false
vim.opt.expandtab = true
vim.opt.fillchars = {
  diff = "∙",
  eob = " ",
  fold = "·",
  vert = " ",
}
vim.opt.foldenable = false
vim.opt.formatoptions:append("1rnq")
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
end
vim.opt.grepformat = "%f:%l:%m"
vim.opt.ignorecase = true
vim.opt.laststatus = 2
vim.opt.lazyredraw = true
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
vim.opt.pumblend = 10
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
vim.opt.tabline = "%!bti#tabline#line()"
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
