"------------------------------------------------------------------------------
" This is my vimrc file - it changes often
" Author: Brandon Iffert <brandoniffert@gmail.com>
" Source: https://github.com/brandoniffert/dotfiles/blob/master/vimrc
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" SETUP
"------------------------------------------------------------------------------
au!
filetype off

" Bootstrap vim-plug on a fresh install
if !filereadable(expand("~/.vim/autoload/plug.vim"))
  !curl -fLo ~/.vim/autoload/plug.vim
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrap=1
endif

call plug#begin()
runtime macros/matchit.vim
Plug 'bling/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'danro/rename.vim'
Plug 'ervandew/supertab'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'mattn/emmet-vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'skalnik/vim-vroom'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Colors
Plug 'chriskempson/base16-vim'

" Syntax
Plug 'cakebaker/scss-syntax.vim'
Plug 'groenewege/vim-less'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
call plug#end()

if exists("s:bootstrap") && s:bootstrap
  unlet s:bootstrap
  PlugInstall
endif

filetype plugin indent on

"------------------------------------------------------------------------------
" GENERAL
"------------------------------------------------------------------------------
set autoread                         " update a open file edited outside of Vim
set backspace=eol,start,indent       " common sense backspacing
set clipboard=
set complete-=i                      " don't scan included files
set cursorline                       " highlight current line
set dictionary+=/usr/share/dict/words
set encoding=utf-8
set fileformats+=mac
set foldmethod=marker
set foldlevelstart=0                 " close folds by default
set formatoptions=qrn1j
set hidden                           " keep buffers around
set history=500
set laststatus=2                     " keep statusline visible
set lazyredraw                       " only redraw if needed
set nojoinspaces                     " only one space after joining lines
set noshowmode                       " mode is shown using Airline
set notimeout ttimeout ttimeoutlen=10
set nrformats-=octal                 " allow incrementing 001 to 002 with <C-a>
set number relativenumber            " show number and relativenumber
set switchbuf+=useopen
set splitbelow splitright            " put new windows to bottom/right
set scrolloff=3                      " keep 3 lines of context around cursor
set shell=/bin/bash\ --login
set synmaxcol=800                    " don't syntax highlight after 800 columns
set t_ti= t_te=                      " don't clear scrollback buffer on quit
set textwidth=79

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
let &listchars="tab:\u2593-,trail:\u2591,extends:>,precedes:<,nbsp:\u00b7"

" Searching
set showmatch incsearch hlsearch ignorecase smartcase

" Remap leader
let mapleader="\<space>"

"------------------------------------------------------------------------------
" STATUSLINE
"------------------------------------------------------------------------------
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

"------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"------------------------------------------------------------------------------
syntax enable

" Use a custom colors file - wraps base16 colorscheme
colorscheme bti-dark
set bg=dark

"------------------------------------------------------------------------------
" KEY MAPS
"------------------------------------------------------------------------------
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
vnoremap <tab> >gv
vnoremap <s-tab> <gv

" Make S split lines (opposite of J)
nnoremap S i<cr><esc>k$

" Yank/paste using system clipboard
vnoremap <leader>y "*y
nnoremap <leader>p "*p

" Make Y act like other capital letters
nnoremap Y y$

" Quick quit window and delete buffer
nnoremap <silent><leader>q :bd<cr>

"------------------------------------------------------------------------------
" PLUGINS
"------------------------------------------------------------------------------
" Airline
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#themes#base16#constant = 1
let g:airline_theme = 'base16'

" Setup vroom for ruby/rspec tests
let g:vroom_map_keys = 0
let g:vroom_use_binstubs = 1
let g:vroom_clear_screen = 0
nnoremap <silent><leader>t :VroomRunTestFile<cr>

" Syntastic
let g:syntastic_mode_map={ 'mode': 'active',
                         \ 'active_filetypes': [],
                         \ 'passive_filetypes': ['html'] }

" Vim sneak
let g:sneak#streak = 1

" Easy align - start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" CtrlP
let g:ctrlp_max_height = 20
let g:ctrlp_show_hidden = 1
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_map = '<leader>f'

" Have ctrlp use ag if available - much faster
if executable("ag")
  let g:ctrlp_user_command = 'ag %s -l -S --hidden -g ""'
endif

nnoremap <silent><leader>b :CtrlPBuffer<cr>

"------------------------------------------------------------------------------
" AUTOCOMMANDS
"------------------------------------------------------------------------------
if has("autocmd")
  augroup bti-vimrc
    au!
    au WinEnter * set cursorline
    au WinLeave * set nocursorline
    au VimResized * wincmd =

    " When editing a file, always jump to the last known cursor position.
    au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  augroup END
endif

"------------------------------------------------------------------------------
" COMMANDS - AUTOLOADED FROM vim/autoload/bti
"------------------------------------------------------------------------------
command! ReplaceFancyCharacters call bti#fancycharacters#replace()
command! StripWhitespace call bti#whitespace#strip()
command! ToggleColorColumn call bti#colorcolumn#toggle()
nnoremap <silent><leader>r :call bti#runcurrentfile#run()<cr>
