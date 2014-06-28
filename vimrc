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

" bootstrap vundle on a fresh install
if !isdirectory(expand("~/.vim/bundle/vundle"))
  !git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  let s:bootstrap=1
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" plugins
Plugin 'Lokaltog/vim-easymotion'
Plugin 'danro/rename.vim'
Plugin 'ervandew/supertab'
Plugin 'gmarik/vundle'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'skalnik/vim-vroom'
Plugin 'tmhedberg/matchit'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'

" colors
Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/base16-vim'

" syntax/ft
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'groenewege/vim-less'
Plugin 'johnhamelink/blade.vim'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-markdown'

if exists("s:bootstrap") && s:bootstrap
  unlet s:bootstrap
  PluginInstall
endif

filetype plugin indent on

"------------------------------------------------------------------------------
" GENERAL
"------------------------------------------------------------------------------
set autoread                         " update a open file edited outside of Vim
set backspace=eol,start,indent       " common sense backspacing
set clipboard=
set cursorline                       " highlight current line
set dictionary=/usr/share/dict/words
set encoding=utf-8
set formatoptions=qrn1j
set hidden                           " keep buffers around
set history=500
set laststatus=2                     " keep statusline visible
set lazyredraw                       " only redraw if needed
set nojoinspaces                     " only one space after joining lines
set number
set relativenumber
set splitbelow splitright            " put new windows to bottom/right
set scrolloff=3                      " keep 3 lines of context around cursor
set shell=/bin/bash
set showbreak=↪
set showcmd                          " display incomplete commands
set synmaxcol=800                    " don't syntax highlight after 800 columns
set t_ti= t_te=                      " don't clear scrollback buffer on quit
set textwidth=79
set notimeout ttimeout ttimeoutlen=10

" using the old regexp engine in 7.4 speeds up ruby syntax highlighting
" http://stackoverflow.com/a/16920294
if v:version > 703
  set regexpengine=1
endif

" tabs & indenting
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set shiftround
set autoindent smarttab smartindent

" no backups or swap file
set nobackup nowritebackup noswapfile

" wildmenu
set wildmenu
set wildmode=longest,list
set wildignore+=.git,.svn,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.sw?,*.DS_Store,*.pyc.*/tmp/*,*.so,*.zip

" completion options
set complete-=i
set completeopt=menu,longest,preview
set pumheight=15

" searching
set showmatch incsearch hlsearch ignorecase smartcase

" folding
set foldmethod=marker
set foldlevelstart=0

" remap leader
let mapleader="\<space>"

"------------------------------------------------------------------------------
" STATUSLINE
"------------------------------------------------------------------------------
set statusline=                           " clear
set statusline+=[%n]                      " buffer number
set statusline+=\ %f                      " file path
set statusline+=\ (%{&filetype})          " file type
set statusline+=\ %m%r%w%h                " modified/read-only/preview/help
set statusline+=%=                        " left/right separator
set statusline+=%{&fileformat}\ \|        " file format
set statusline+=\ %{&fileencoding}\ \|    " file encoding
set statusline+=\ %l\/%L:%c\              " line/column number

"------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"------------------------------------------------------------------------------
syntax enable

" read PROFILE_BG enviornment variable and set colors accordingly
if $PROFILE_BG == 'light'
  set bg=light
  colorscheme solarized
else
  set bg=dark
  colorscheme bti-base16-override
endif

if exists('$TMUX')
  set cmdheight=2
endif

"------------------------------------------------------------------------------
" KEY MAPS
"------------------------------------------------------------------------------
nnoremap j gj
nnoremap k gk

" <cr> clears the highlighted search
nnoremap <silent> <cr> :nohlsearch<cr>

" make S split lines (opposite of J)
nnoremap S i<cr><esc>k$

" use hjkl for switching between splits
nnoremap <c-j> <c-W>j
nnoremap <c-h> <c-W>h
nnoremap <c-k> <c-W>k
nnoremap <c-l> <c-W>l

" select text that was just pasted
nnoremap <leader>gv V`]

" create a new vertical/horizontal window
nnoremap <silent> <leader>v :vnew<cr>
nnoremap <silent> <leader>h :new<cr>

" quick jump back and forth between files
nnoremap <leader><leader> <c-^>

" change working directory to file being edited, print after
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" easy indent/outdent
nnoremap <tab> >>
nnoremap <s-tab> <<
vnoremap <tab> >gv
vnoremap <s-tab> <gv

" yank to system clipboard
nnoremap <leader>y "*y
vnoremap <leader>y "*y

" paste from system clipboard
nnoremap <leader>p "*p

" toggle spell check
nnoremap <silent> <leader>ss :setlocal spell!<cr>

" make Y act like other capital letters
nnoremap Y y$

" quick quit window
nnoremap <silent> <c-\> :q<cr>

" open directory of file in Finder
if has('mac')
  nnoremap <silent> <c-o> :silent !open %:p:h<cr>
endif

"------------------------------------------------------------------------------
" PLUGINS
"------------------------------------------------------------------------------
nnoremap <leader>a :Ag<space>

" easymotion
let g:EasyMotion_leader_key = '<leader>e'

" setup vroom for ruby/rspec tests
let g:vroom_map_keys = 0
let g:vroom_use_binstubs = 1
let g:vroom_clear_screen = 0
nnoremap <silent> <leader>t :VroomRunTestFile<cr>

" syntastic
let g:syntastic_mode_map={ 'mode': 'active',
                         \ 'active_filetypes': [],
                         \ 'passive_filetypes': ['html'] }

" nerdtree
nnoremap <silent> <c-n> :NERDTreeToggle<cr>

" supertab
let g:SuperTabDefaultCompletionType = "context"

" use ctrlp
let g:ctrlp_max_height = 25
let g:ctrlp_show_hidden = 1
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 0
nnoremap <silent> <leader>f :CtrlPClearCache<cr>\|:CtrlPCurWD<cr>

" have ctrlp use ag if available - much faster
if executable("ag")
  let g:ctrlp_user_command = 'ag %s -l -S --nocolor --hidden -g ""'
endif

"------------------------------------------------------------------------------
" AUTOCOMMANDS
"------------------------------------------------------------------------------
if has("autocmd")
  augroup bti-vimrc
    au!
    au FileType text,markdown set spell
    au FileType python set sw=4 sts=4 et

    au BufNewFile,BufRead *.ss silent set ft=html
    au BufNewFile,BufRead *.blade.php silent set ft=blade.html
    au BufRead,BufNewFile *.scss set filetype=scss

    " fixes issue with statusline not being drawn in full screen iTerm2
    au VimEnter * :sleep 5m

    " automatically source this file on save
    au BufWritePost vimrc source %

    " only show cursorline in active window
    au WinEnter * set cursorline
    au WinLeave * set nocursorline

    " resize splits when window is resized
    au VimResized * :wincmd =

    " When editing a file, always jump to the last known cursor position.
    au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  augroup END
endif

"------------------------------------------------------------------------------
" RUN CURRENT FILE
"------------------------------------------------------------------------------
function! RunCurrentFile()
  if &ft == 'ruby'   | let l:runftcmd = 'ruby %'   | endif
  if &ft == 'php'    | let l:runftcmd = 'php -f %' | endif
  if &ft == 'python' | let l:runftcmd = 'python %' | endif
  if &ft == 'sh'     | let l:runftcmd = 'bash %'   | endif

  if !exists('l:runftcmd')
    echo "Unrecognized run filetype command!"
  else
    exec ':w |:!' . l:runftcmd
  end
endfunction
nnoremap <leader>r :call RunCurrentFile()<cr>

"------------------------------------------------------------------------------
" REMOVE FANCY CHARACTERS
"------------------------------------------------------------------------------
function! RemoveFancyCharacters()
  let typo = {}
  let typo["“"] = '"'
  let typo["”"] = '"'
  let typo["‘"] = "'"
  let typo["’"] = "'"
  let typo["–"] = '--'
  let typo["—"] = '---'
  let typo["…"] = '...'
  :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

"------------------------------------------------------------------------------
" TOGGLE COLORCOLUMN
"------------------------------------------------------------------------------
function! g:ToggleColorColumn()
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=+1
  endif
endfunction
nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<cr>
