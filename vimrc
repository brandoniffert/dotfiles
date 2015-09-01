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
Plug 'bling/vim-airline'
Plug 'cakebaker/scss-syntax.vim'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'janko-m/vim-test'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'rking/ag.vim', { 'on': 'Ag' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
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
set complete-=i                       " don't scan included files
set dictionary+=/usr/share/dict/words
set fileformats+=mac
set foldlevelstart=0                  " close folds by default
set foldmethod=marker
set formatoptions=qrn1j
set hidden                            " keep buffers around
set history=500
set laststatus=2                      " keep statusline visible
set lazyredraw                        " only redraw if needed
set nocursorline
set nojoinspaces                      " only one space after joining lines
set noshowmode                        " mode is shown using Airline
set notimeout ttimeout ttimeoutlen=10
set nrformats-=octal                  " allow incrementing 001 to 002 with <C-a>
set number relativenumber             " show number and relativenumber
set scrolloff=3
set shell=/bin/bash
set showcmd
set splitbelow splitright             " put new windows to bottom/right
set switchbuf+=useopen
set synmaxcol=500                     " don't syntax highlight after 500 columns
set textwidth=80

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
set showbreak=↪
let &listchars="tab:\u25B8-,trail:\u2022,extends:>,precedes:<,nbsp:\u00b7"

" Searching
set showmatch incsearch hlsearch ignorecase smartcase

" Remap leader
let mapleader="\<space>"

"-------------------------------------------------------------------------------
" STATUSLINE
"-------------------------------------------------------------------------------
if !exists('g:loaded_airline')
  set statusline=                           " reset
  set statusline+=[%n]                      " buffer number
  set statusline+=\ %f                      " file path
  set statusline+=\ (%{&filetype})          " file type
  set statusline+=\ %m%r%w%h                " modified/read-only/preview/help
  set statusline+=%=                        " left/right separator
  set statusline+=%{&fileformat}\ \|        " file format
  set statusline+=\ %{&fileencoding}\ \|    " file encoding
  set statusline+=\ %l\/%L:%c\              " line/column number
endif

"-------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"-------------------------------------------------------------------------------
syntax enable
syntax sync minlines=256

" Use a custom colors file - wraps base16 colorscheme
colorscheme bti-dark
set bg=dark

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

" Create a new vertical/horizontal window
nnoremap <silent><leader>v :vnew<cr>
nnoremap <silent><leader>h :new<cr>

" Select text that was just pasted
nnoremap <leader>gv V`]

" Quick jump back and forth between files
nnoremap <leader><leader> <c-^>

" Easy indent/outdent
nnoremap <tab> >>
nnoremap <s-tab> <<
xnoremap <tab> >gv
xnoremap <s-tab> <gv

" When jump to next match also center screen
noremap n nzz
noremap N Nzz

" Make S split lines (opposite of J)
nnoremap S i<cr><esc>k$

" Yank/paste using system clipboard
xnoremap <leader>y "*y
nnoremap <leader>p "*p

" Make Y act like other capital letters
nnoremap Y y$

" Quick replay recorded macro
nnoremap Q @@

" Quick quit window and delete buffer
nnoremap <silent><leader>q :bd<cr>

" Run current file using makeprg
nnoremap <silent><leader>r :make!<cr>

"-------------------------------------------------------------------------------
" PLUGINS
"-------------------------------------------------------------------------------
" Polyglot
let g:polyglot_disabled = ['css']

" Airline
let [g:airline_left_sep, g:airline_right_sep] = ['', '']
let [g:airline#themes#base16#constant, g:airline_theme] = [1, 'base16']

" Vim sneak
let g:sneak#streak = 1

" Vim test
nnoremap <silent> <leader>t :TestFile<CR>

" Easy align - start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" CtrlP
let g:ctrlp_max_height = 20
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_map = '<leader>f'
nnoremap <silent><leader>b :CtrlPBuffer<cr>

" Ultisnips
let g:UltiSnipsExpandTrigger = '<tab>'

" Have ctrlp use ag if available
if executable("ag")
  let g:ctrlp_user_command = 'ag %s -l -S --hidden -g ""'
endif

"-------------------------------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------------------------------
if has("autocmd")
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
endif

"-------------------------------------------------------------------------------
" COMMANDS - AUTOLOADED FROM vim/autoload/bti
"-------------------------------------------------------------------------------
command! ReplaceFancyCharacters call bti#fancycharacters#replace()
command! StripWhitespace call bti#whitespace#strip()
command! ToggleColorColumn call bti#colorcolumn#toggle()
