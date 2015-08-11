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
Plug 'bling/vim-airline'
Plug 'danro/rename.vim'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'skalnik/vim-vroom'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Colors
Plug 'chriskempson/base16-vim'

" Syntax
Plug 'cakebaker/scss-syntax.vim'
Plug 'chrisbra/csv.vim'
Plug 'groenewege/vim-less'
Plug 'klen/python-mode'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'StanAngeloff/php.vim'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
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
set cursorline                        " highlight current line
set dictionary+=/usr/share/dict/words
set fileformats+=mac
set foldmethod=marker
set foldlevelstart=0                  " close folds by default
set formatoptions=qrn1j
set hidden                            " keep buffers around
set history=500
set laststatus=2                      " keep statusline visible
set lazyredraw                        " only redraw if needed
set noshowmode                        " mode is shown using Airline
set nojoinspaces                      " only one space after joining lines
set notimeout ttimeout ttimeoutlen=10
set nrformats-=octal                  " allow incrementing 001 to 002 with <C-a>
set number relativenumber             " show number and relativenumber
set scrolloff=3
set shell=/bin/bash
set splitbelow splitright             " put new windows to bottom/right
set switchbuf+=useopen
set synmaxcol=500                     " don't syntax highlight after 500 columns
set t_ti= t_te=                       " don't clear scrollback buffer on quit
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
let &listchars="tab:\u2593-,trail:\u2591,extends:>,precedes:<,nbsp:\u00b7"

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

"-------------------------------------------------------------------------------
" PLUGINS
"-------------------------------------------------------------------------------
" Airline
let [g:airline_left_sep, g:airline_right_sep] = ['', '']
let [g:airline#themes#base16#constant, g:airline_theme] = [1, 'base16']

" Setup vroom for ruby/rspec tests
let [g:vroom_map_keys, g:vroom_use_binstubs, g:vroom_clear_screen] = [0, 1, 0]
nnoremap <silent><leader>t :VroomRunTestFile<cr>

" Syntastic
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['html'] }

" Vim sneak
let g:sneak#streak = 1

" Easy align - start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Have FZF use ag if available
if executable("ag")
  let bti_fzf_source = 'ag -l -S --hidden -g ""'
else
  let bti_fzf_source = 'find .'
endif

" FZF
nnoremap <silent><leader>f :call fzf#run({
\   'source':  bti_fzf_source,
\   'sink':    'e',
\   'down':    20
\ })<CR>

" CSV
let g:csv_autocmd_arrange = 1

" Pymode
let g:pymode_virtualenv = 0
let g:pymode_run = 0
let g:pymode_folding = 0
let g:pymode_rope = 0
let g:pymode_lint_ignore = "E501"

"-------------------------------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------------------------------
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

"-------------------------------------------------------------------------------
" COMMANDS - AUTOLOADED FROM vim/autoload/bti
"-------------------------------------------------------------------------------
command! ReplaceFancyCharacters call bti#fancycharacters#replace()
command! StripWhitespace call bti#whitespace#strip()
command! ToggleColorColumn call bti#colorcolumn#toggle()
nnoremap <silent><leader>r :call bti#runcurrentfile#run()<cr>
