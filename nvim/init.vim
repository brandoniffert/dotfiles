"-------------------------------------------------------------------------------
" This is my nvim init file - it changes often
" Author: Brandon Iffert <brandoniffert@gmail.com>
" Source: https://github.com/brandoniffert/dotfiles/blob/master/nvim/init.vim
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" SETUP
"-------------------------------------------------------------------------------
au!
filetype off

" Bootstrap vim-plug on a fresh install
if !filereadable(expand("~/.config/nvim/autoload/plug.vim"))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrap=1
endif

call plug#begin()
runtime macros/matchit.vim
Plug 'arcticicestudio/nord-vim'
Plug 'benekastah/neomake'
Plug 'ervandew/supertab'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tweekmonster/django-plus.vim'
Plug 'vim-airline/vim-airline'
call plug#end()

if exists("s:bootstrap") && s:bootstrap
  unlet s:bootstrap
  PlugInstall
endif

filetype plugin indent on

" Setup yankstack before any other configurations
call yankstack#setup()

"-------------------------------------------------------------------------------
" GENERAL SETTINGS
"-------------------------------------------------------------------------------
set clipboard=
set dictionary+=/usr/share/dict/words
set fileformats+=mac
set foldlevelstart=0
set foldmethod=marker
set formatoptions+=qrn1j
set hidden
set lazyredraw
set mouse=
set nocursorline
set nojoinspaces
set noshowmode
set number relativenumber
set ruler
set scrolloff=3
set shell=/bin/bash
set showcmd
set splitbelow splitright
set switchbuf+=useopen
set termguicolors
set textwidth=80

" Set custom spellfile
if filereadable(expand("~/.vim-custom.en.utf8.add"))
  set spellfile=~/.vim-custom.en.utf8.add
endif

" Tabs & Indenting
set smartindent
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set shiftround

" No backups or swap file
set nobackup nowritebackup noswapfile

" Wildmenu
set wildmode=longest,list
set wildignore+=.svn,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.sw?,*.DS_Store,*.pyc.*/tmp/*,*.so,*.zip

" Show invisible characters
set list
let &listchars="tab:>-,trail:.,extends:>,precedes:<,nbsp:\u00b7"

" Searching
set showmatch incsearch hlsearch ignorecase smartcase

" Remap leader
let mapleader="\<space>"

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2

"-------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"-------------------------------------------------------------------------------
syntax enable
colorscheme nord

hi Comment guifg=#5d6980
hi IncSearch guifg=#3b4252 guibg=#EBCB8B
hi Search guifg=#bf616a guibg=NONE gui=underline

" Airline
let g:airline_theme = 'nord'
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ }

" Make sure bash scripts are colored fully
let g:is_bash = 1

"-------------------------------------------------------------------------------
" KEY MAPS
"-------------------------------------------------------------------------------
" Navigate over wrapped lines
nnoremap j gj
nnoremap k gk

" <cr> clears the highlighted search
nnoremap <silent><cr> :noh<cr>

" Use hjkl for switching between splits
nnoremap <c-j> <c-W>j
nnoremap <c-h> <c-W>h
nnoremap <c-k> <c-W>k
nnoremap <c-l> <c-W>l

" Select text that was just pasted
nnoremap <leader>gv V`]

" Quick jump back and forth between files
nnoremap <leader><leader> <c-^>

" Easy indent/outdent
nnoremap <tab> >>
nnoremap <s-tab> <<
vnoremap <tab> >gv
vnoremap <s-tab> <gv

" Make S split lines (opposite of J)
nnoremap S i<cr><esc>k$

" Open new vertical split
nnoremap <silent><leader>v :vnew<cr>

" Yank/paste using system clipboard
vnoremap <leader>y "*y
nnoremap <leader>p "*p

" Make Y act like other capital letters
nnoremap Y y$

" Hack to get C-h working in neovim
nmap <BS> <C-W>h

" Run current file using makeprg
nnoremap <leader>r :make!<cr>

"-------------------------------------------------------------------------------
" PLUGINS
"-------------------------------------------------------------------------------
" Vim test
nnoremap <silent><leader>t :TestFile<CR>

" Neomake
let g:neomake_html_enabled_makers = []

" Ripgrep
set grepprg=rg\ --vimgrep

" FZF
let g:fzf_layout = { 'down': '~25%' }

nnoremap <silent><leader>f :Files<cr>
nnoremap <silent><leader>b :Buffers<cr>

function! s:fzf_statusline()
  highlight fzf1 guibg=#4E5668
  setlocal statusline=%#fzf1#\ >\ fzf
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

"-------------------------------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------------------------------
augroup bti-vimrc
  au!
  au! VimResized * wincmd =
  au! BufWritePost * Neomake

  " When editing a file, always jump to the last known cursor position.
  au! BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
    noh
augroup END

"-------------------------------------------------------------------------------
" COMMANDS - AUTOLOADED FROM vim/autoload/bti
"-------------------------------------------------------------------------------
command! ReplaceFancyCharacters call bti#fancycharacters#replace()
command! StripWhitespace call bti#whitespace#strip()
command! ToggleColorColumn call bti#colorcolumn#toggle()
