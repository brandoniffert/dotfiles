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

" bootstrap vim-plug on a fresh install
if !filereadable(expand("~/.vim/autoload/plug.vim"))
  !curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrap=1
endif

call plug#begin()
Plug 'bling/vim-airline'
Plug 'danro/rename.vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'kien/ctrlp.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'skalnik/vim-vroom'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" colors
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'

" syntax/ft
Plug 'cakebaker/scss-syntax.vim'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'groenewege/vim-less'
Plug 'johnhamelink/blade.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
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
set cursorline                       " highlight current line
set dictionary=/usr/share/dict/words
set encoding=utf-8
set formatoptions=qrn1j
set hidden                           " keep buffers around
set history=500
set laststatus=2                     " keep statusline visible
set lazyredraw                       " only redraw if needed
set nojoinspaces                     " only one space after joining lines
set noshowmode
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
else
  set bg=dark
endif

if exists('$BASE16_THEME')
  let base16colorspace=256
  let s:bti_colorscheme = 'base16-' . $BASE16_THEME
elseif $PROFILE_COLORSCHEME == 'solarized'
  let s:bti_colorscheme = 'solarized'
else
  let s:bti_colorscheme = 'Tomorrow-Night'
endif
exec 'colorscheme ' . s:bti_colorscheme

hi Normal ctermbg=NONE

" highlight fixes for base16 themes
if exists('$BASE16_THEME')
  hi LineNr ctermbg=NONE ctermfg=237
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

" use hjkl for switching between splits
nnoremap <c-j> <c-W>j
nnoremap <c-h> <c-W>h
nnoremap <c-k> <c-W>k
nnoremap <c-l> <c-W>l

" create a new vertical/horizontal window
nnoremap <silent> <leader>v :vnew<cr>
nnoremap <silent> <leader>h :new<cr>

" make S split lines (opposite of J)
nnoremap S i<cr><esc>k$

" select text that was just pasted
nnoremap <leader>gv V`]

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

" quick quit window and delete buffer
nnoremap <silent> <c-\> :bd<cr>

" open directory of file in Finder
if has('mac')
  nnoremap <silent> <c-o> :silent !open %:p:h<cr>
endif

"------------------------------------------------------------------------------
" PLUGINS
"------------------------------------------------------------------------------
nnoremap <leader>a :Ag<space>

" airline
let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#themes#base16#constant = 1
let g:airline_theme = g:colors_name == 'solarized' ? 'solarized' : 'base16'
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

" supertab
let g:SuperTabDefaultCompletionType = "context"

" ctrlp
let g:ctrlp_max_height = 25
let g:ctrlp_show_hidden = 1
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 0

" have ctrlp use ag if available - much faster
if executable("ag")
  let g:ctrlp_user_command = 'ag %s -l -S --nocolor --hidden -g ""'
endif

nnoremap <silent><leader>f :CtrlPClearCache<cr>\|:CtrlPCurWD<cr>
nnoremap <silent><leader>b :CtrlPBuffer<cr>

"------------------------------------------------------------------------------
" SELECTA
"------------------------------------------------------------------------------
if executable('selecta')
  function! SelectaCommand(choice_command, selecta_args, vim_command)
    try
      let selection = system(a:choice_command . " | selecta " . a:selecta_args)
    catch /Vim:Interrupt/
      " Swallow the ^C so that the redraw below happens; otherwise there will be
      " leftovers from selecta on the screen
      redraw!
      return
    endtry
    redraw!
    exec a:vim_command . " " . selection
  endfunction

  let selecta_search_command = 'ag -l -S --nocolor --hidden -g ""'
  nnoremap <silent><leader>f :call SelectaCommand(selecta_search_command, "", ":e")<cr>
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

  augroup vimrc-reload
    au!
    " automatically source this file on save
    au BufWritePost vimrc source $MYVIMRC | :AirlineRefresh
  augroup END
endif

"------------------------------------------------------------------------------
" RUN CURRENT FILE
"------------------------------------------------------------------------------
function! RunCurrentFile()
  let types = {
    \ 'ruby' : 'ruby',
    \ 'php' : 'php -f',
    \ 'python' : 'python',
    \ 'sh' : 'bash'
    \ }

  exec "w"
  if has_key(types, &ft)
    exec "!" . types[&ft] . " " . expand("%")
  else
    echo "Unrecognized run filetype command!"
  endif
endfunction
nnoremap <silent><leader>r :call RunCurrentFile()<cr>

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
" CLEAR WHITESPACE
"------------------------------------------------------------------------------
function! ClearWhitespace()
  normal mi
  try
    %s/\s\+$//
  catch /^Vim\%((\a\+)\)\=:E486/
  endtry
  let @/=""
  normal `i
endfunction
command! ClearWhitespace :call ClearWhitespace()

"------------------------------------------------------------------------------
" TOGGLE COLORCOLUMN
"------------------------------------------------------------------------------
function! ToggleColorColumn()
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=+1
  endif
endfunction
command! ToggleColorColumn :call ToggleColorColumn()
