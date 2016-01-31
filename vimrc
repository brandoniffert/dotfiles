"-------------------------------------------------------------------------------
" This is my vimrc file - it changes often
" Author: Brandon Iffert <brandoniffert@gmail.com>
" Source: https://github.com/brandoniffert/dotfiles/blob/master/vimrc
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" SETUP
"-------------------------------------------------------------------------------
au!
filetype off

" Bootstrap vim-plug on a fresh install
if !filereadable(expand("~/.vim/autoload/plug.vim"))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrap=1
endif

call plug#begin()
runtime macros/matchit.vim
Plug 'benekastah/neomake', { 'on': 'Neomake' }
Plug 'cakebaker/scss-syntax.vim'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'gavocanov/vim-js-indent'
Plug 'janko-m/vim-test'
Plug 'junegunn/vim-easy-align'
Plug 'othree/yajs.vim'
Plug 'rking/ag.vim', { 'on': 'Ag' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has('python')
  Plug 'SirVer/ultisnips'
endif
call plug#end()

if exists("s:bootstrap") && s:bootstrap
  unlet s:bootstrap
  PlugInstall
endif

filetype plugin indent on

"-------------------------------------------------------------------------------
" GENERAL SETTINGS
"-------------------------------------------------------------------------------
set autoread                          " update open files edited outside of Vim
set backspace=eol,start,indent        " common sense backspacing
set clipboard=
set complete-=i
set dictionary+=/usr/share/dict/words
set fileformats+=mac
set foldlevelstart=0                  " close folds by default
set foldmethod=marker
set formatoptions=qrn1j
set hidden                            " keep buffers around
set laststatus=2                      " keep statusline visible
set lazyredraw                        " only redraw if needed
set mouse=
set nocursorline
set nojoinspaces                      " only one space after joining lines
set noshowmode
set notimeout ttimeout ttimeoutlen=10
set nrformats-=octal                  " allow incrementing 001 to 002 with <C-a>
set number relativenumber             " show number and relativenumber
set ruler
set scrolloff=3
set shell=/bin/bash
set showcmd
set splitbelow splitright             " put new windows to bottom/right
set switchbuf+=useopen
set textwidth=80
set ttyfast

" Set custom spellfile
if filereadable(expand("~/.vim-custom.en.utf8.add"))
  set spellfile=~/.vim-custom.en.utf8.add
endif

" Tabs & Indenting
set autoindent smarttab smartindent
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set shiftround

" No backups or swap file
set nobackup nowritebackup noswapfile

" Wildmenu
set wildmenu
set wildmode=longest,list
set wildignore+=.git,.svn,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.sw?,*.DS_Store,*.pyc.*/tmp/*,*.so,*.zip

" Show invisible characters
set list
let &listchars="tab:>-,trail:.,extends:>,precedes:<,nbsp:\u00b7"

" Searching
set showmatch incsearch hlsearch ignorecase smartcase

" Remap leader
let mapleader="\<space>"

"-------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"-------------------------------------------------------------------------------
syntax enable
colorscheme bti-dark

" Make sure bash scripts are colored fully
let g:is_bash = 1

"-------------------------------------------------------------------------------
" KEY MAPS
"-------------------------------------------------------------------------------
" Navigate over wrapped lines
nnoremap j gj
nnoremap k gk

" <cr> clears the highlighted search
nnoremap <silent><cr> :nohlsearch<cr>

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

" Run current file using makeprg
nnoremap <leader>r :make!<cr>

" Hack to get C-h working in neovim
if has('nvim')
  nmap <BS> <C-W>h
endif

"-------------------------------------------------------------------------------
" PLUGINS
"-------------------------------------------------------------------------------
" Vim test
nnoremap <silent><leader>t :TestFile<CR>

" Polyglot
let g:polyglot_disabled = ['css', 'javascript']

" CtrlP
let g:ctrlp_max_height = 25
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode= 0
let g:ctrlp_map = '<leader>f'
nnoremap <silent><leader>b :CtrlPBuffer<cr>

" Have ctrlp use ag if available
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l -S --hidden -g ""'
endif

" Ultisnips
let g:UltiSnipsExpandTrigger = '<c-e>'

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
augroup END

"-------------------------------------------------------------------------------
" COMMANDS - AUTOLOADED FROM vim/autoload/bti
"-------------------------------------------------------------------------------
command! ReplaceFancyCharacters call bti#fancycharacters#replace()
command! StripWhitespace call bti#whitespace#strip()
command! ToggleColorColumn call bti#colorcolumn#toggle()
