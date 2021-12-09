-------------------------------------------------------------------------------
-- Bootstrap ------------------------------------------------------------------
-------------------------------------------------------------------------------

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local needs_bootstrap = vim.fn.isdirectory(install_path) == 0

if not needs_bootstrap then
  require 'impatient'
end

if needs_bootstrap then
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

require 'bti'
require 'bti.plugins'

if needs_bootstrap then
  require('packer').sync()
end

-------------------------------------------------------------------------------
-- Globals --------------------------------------------------------------------
-------------------------------------------------------------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Disable built-ins
local disabled_built_ins = {
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'gzip',
    'zip',
    'zipPlugin',
    'tar',
    'tarPlugin',
    'getscript',
    'getscriptPlugin',
    'vimball',
    'vimballPlugin',
    '2html_plugin',
    'logipat',
    'rrhelper',
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

-- https://github.com/nathom/filetype.nvim#usage
vim.g.did_load_filetypes = 1

-------------------------------------------------------------------------------
-- Options --------------------------------------------------------------------
-------------------------------------------------------------------------------

local home = vim.env.HOME
local root = vim.env.USER == 'root'

vim.opt.autoindent     = true
vim.opt.backspace      = 'indent,start,eol'
vim.opt.backup         = false
vim.opt.backupcopy     = 'yes'
vim.opt.belloff        = 'all'
vim.opt.completeopt    = 'menuone,noselect'
vim.opt.diffopt:append('foldcolumn:0')
vim.opt.emoji          = false
vim.opt.expandtab      = true
vim.opt.fillchars      = {
  diff                 = '∙',
  eob                  = ' ',
  fold                 = '·',
  vert                 = ' ',
}
vim.opt.foldenable     = false
vim.opt.formatoptions:append('1rnq')
vim.opt.grepformat     = '%f:%l:%m'
vim.opt.ignorecase     = true
vim.opt.laststatus     = 2
vim.opt.lazyredraw     = true
vim.opt.linebreak      = false
vim.opt.list           = true
vim.opt.listchars      = {
  nbsp                 = '⦸',
  extends              = '»',
  precedes             = '«',
  tab                  = '▷⋯',
  trail                = '•',
}
vim.opt.modelines      = 5
vim.opt.mouse          = 'a'
vim.opt.number         = true
vim.opt.pumblend       = 10
vim.opt.relativenumber = true
vim.opt.scrolloff      = 3
vim.opt.showmode       = false

if root then
  vim.opt.shada        = ''
  vim.opt.shadafile    = 'NONE'
end

vim.opt.shiftround     = false
vim.opt.shiftwidth     = 2
vim.opt.shortmess      = 'AFOTWacot'
vim.opt.showbreak      = '↳ '
vim.opt.showcmd        = false
vim.opt.showmatch      = true
vim.opt.sidescroll     = 0
vim.opt.sidescrolloff  = 3
vim.opt.signcolumn     = 'yes'
vim.opt.smartcase      = true
vim.opt.smarttab       = true
vim.opt.softtabstop    = -1
vim.opt.spellcapcheck  = ''

local spell_path = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'

if vim.fn.filereadable(spell_path) == 1 then
  vim.opt.spellfile    = spell_path
end

vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.swapfile       = false
vim.opt.switchbuf      = 'usetab'
vim.opt.synmaxcol      = 200
vim.opt.tabstop        = 2
vim.opt.tabline        = '%!bti#tabline#line()'
vim.opt.termguicolors  = true
vim.opt.timeoutlen     = 500

if root then
  vim.opt.undofile     = false
else
  vim.opt.undofile     = true
end

vim.opt.updatetime     = 2000
vim.opt.updatecount    = 0
vim.opt.virtualedit    = 'block'
vim.opt.visualbell     = true
vim.opt.whichwrap      = 'b,h,l,s,<,>,[,],~'
vim.opt.wildcharm      = 26
vim.opt.wildignore:append('*.jpg,*.jpeg,*.png,*.gif,*.sw?,*.pyc,*.so,*.DS_Store*/tmp/*')
vim.o.wildmenu         = true
vim.o.wildmode         = 'longest:full,full'
vim.o.writebackup      = false

-------------------------------------------------------------------------------
-- Mappings -------------------------------------------------------------------
-------------------------------------------------------------------------------

local nnoremap = bti.vim.nnoremap
local noremap = bti.vim.noremap
local xnoremap = bti.vim.xnoremap
local vnoremap = bti.vim.vnoremap

-- Navigate over wrapped lines
nnoremap('j', 'gj')
nnoremap('k', 'gk')

-- Enter command mode
nnoremap('<Leader><CR>', ':')
vnoremap('<Leader><CR>', ':')

-- Use hjkl for switching between splits
nnoremap('<C-h>', '<C-W>h')
nnoremap('<C-j>', '<C-W>j')
nnoremap('<C-k>', '<C-W>k')
nnoremap('<C-l>', '<C-W>l')

-- Use arrow keys for tab navigation
nnoremap('<Left>', ':tabp<CR>')
nnoremap('<Right>', ':tabn<CR>')

-- Select text that was just pasted
nnoremap('<Leader>gv', 'V`]')

-- Quick jump back and forth between files
nnoremap('<Leader><Leader>', ":<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>", { silent = true })

-- Quick quit
nnoremap('<Leader>q', ':quit<CR>', { silent = true })
nnoremap('<Leader>Q', ':quitall<CR>', { silent = true })

-- Easy indent/outdent
nnoremap('<Tab>', '>>')
nnoremap('<S-Tab>', '<<')
vnoremap('<Tab>', '>gv')
vnoremap('<S-Tab>', '<gv')

-- Split lines (opposite of J)
nnoremap('|', ':<c-u>call bti#functions#break_here()<CR>', { silent = true })

-- Open new horizontal/vertical split
nnoremap('<Leader>v', ':vnew<CR>', { silent = true })

-- Yank/paste using system clipboard
vnoremap('<Leader>y', '"*y')
nnoremap('<Leader>p', '"*p')

-- Don't replace register with text that was pasted over
xnoremap('p', "p:if v:register == '\"'<bar>let @@=@0<bar>endif<CR>", { silent = true })

-- Run current file using makeprg
nnoremap('<Leader>r', ':make!<CR>')

-- Strip whitespace
nnoremap('<LocalLeader>zz', ':call bti#functions#strip_whitespace()<CR>', { silent = true })

-- Edit file, starting in same directory as current file
nnoremap('<LocalLeader>e', ':edit <C-R>=expand("%:p:h") . "/"<CR>')

-- Print the syntax highlighting group(s) that apply at the current cursor position
nnoremap('<LocalLeader>pH',  ':echomsg v:lua.bti.functions.get_highlight_group()<CR>')

-- Print the TS highlighting group(s) that apply at the current cursor position
nnoremap('<LocalLeader>ph',  '<cmd>TSHighlightCapturesUnderCursor<CR>')

-- Abbreviations
vim.cmd([[iabbrev ;- ->]])
vim.cmd([[iabbrev ;= =>]])

-------------------------------------------------------------------------------
-- Autocommands ---------------------------------------------------------------
-------------------------------------------------------------------------------

local augroup = bti.vim.augroup
local autocmd = bti.vim.autocmd

augroup('BtiAutocmds', function ()
  autocmd('BufEnter', '*', bti.autocmds.buf_enter)
  autocmd('BufWritePre,FileWritePre', '*', 'call bti#functions#create_and_save_directory()')
  autocmd('BufWritePost', '*/spell/*.add', 'silent! :mkspell! %')
  autocmd('FocusGained', '*', bti.autocmds.focus_gained)
  autocmd('FocusLost', '*', bti.autocmds.focus_lost)
  autocmd('InsertLeave', '*', 'set nopaste')
  autocmd('TermOpen', '*', 'setlocal nonumber norelativenumber')
  autocmd('TermOpen', '*', 'startinsert')
  autocmd('TextYankPost', '*', "if v:event.operator is 'y' && v:event.regname is '*' | execute 'OSCYankReg *' | endif | silent! lua vim.highlight.on_yank()")
  autocmd('VimResized', '*', 'execute "normal! \\<c-w>="')
  autocmd('WinEnter', '*', bti.autocmds.win_enter)
  autocmd('WinLeave', '*', bti.autocmds.win_leave)

  autocmd('BufEnter,BufRead,BufNewFile', '*.ss', 'set filetype=html syntax=ss | runtime! indent/ss.vim')

  vim.cmd([[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |  execute 'normal! g`"zvzz' | endif]])
end)

-------------------------------------------------------------------------------
-- Commands -------------------------------------------------------------------
-------------------------------------------------------------------------------

vim.cmd([[command! ReplaceFancyCharacters call bti#functions#replace_fancy_characters()]])
