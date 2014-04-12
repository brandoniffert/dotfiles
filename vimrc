"------------------------------------------------------------------------------
" SETUP
"------------------------------------------------------------------------------
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
Plugin 'scrooloose/syntastic'
Plugin 'skalnik/vim-vroom'
Plugin 'tmhedberg/matchit'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'

" colors
Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/base16-vim'

" syntax/ft
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'evanmiller/nginx-vim-syntax'
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
set autoread
set backspace=eol,start,indent
set clipboard=unnamed
set cursorline
set dictionary=/usr/share/dict/words
set encoding=utf-8
set formatoptions=qrn1j
set hidden
set history=500
set laststatus=2
set lazyredraw
set modelines=3
set nojoinspaces
set relativenumber
set splitbelow
set splitright
set scrolloff=3
set showbreak=↪
set showcmd
set switchbuf=useopen
set synmaxcol=500
set t_ti= t_te=
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
set bg=dark
if $PROFILE_BG == 'light'
  set bg=light
endif

colorscheme bti-base16
if $ITERM_PROFILE =~ 'solarized'
  colorscheme solarized
endif

if exists('$TMUX')
  set cmdheight=2
endif

if has('gui_macvim')
  set showtabline=0
  set guifont=Source\ Code\ Pro:h13
  set guioptions-=r
  set guioptions-=L
  set guioptions-=b
endif

"------------------------------------------------------------------------------
" KEY MAPS
"------------------------------------------------------------------------------
nnoremap j gj
nnoremap k gk

" <cr> clears the highlighted search
nnoremap <silent> <CR> :nohlsearch<cr>

" make S split lines (opposite of J)
nnoremap S i<cr><esc>k$

" use hjkl for switching between splits
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" select text that was just pasted
nnoremap <leader>v V`]

" create a new vertical split window and switch over to it
nnoremap <silent> <leader>sv :vnew<cr>

" create a new horizontal split window
nnoremap <silent> <leader>sh :new<cr>

" jump back and forth between files
nnoremap <leader><leader> <C-^>

" change working directory to file being edited, print after
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" easy indent/outdent
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" yank to system clipboard
nnoremap <leader>y "+y

" paste from system clipboard
nnoremap <leader>p "*p

" toggle spell check
nnoremap <silent> <leader>ss :setlocal spell!<cr>

" make Y act like other capital letters
nnoremap Y y$

" open directory of file in Finder
if has('mac')
  nnoremap <leader>o :silent !open %:p:h<cr>
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
  augroup btivimrc
    au!
    au FileType text,markdown set spell
    au FileType python set sw=4 sts=4 et

    au BufNewFile,BufRead *.ss silent set ft=html
    au BufNewFile,BufRead *.blade.php silent set ft=blade.html
    au BufRead,BufNewFile *.scss set filetype=scss

    " fixes issue with statusline not being drawn in full screen iTerm2 
    au VimEnter * :sleep 5m

    " only show cursorline in active window
    au WinEnter * set cursorline
    au WinLeave * set nocursorline

    " resize splits when window is resized
    au VimResized * :wincmd =

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
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
nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>
