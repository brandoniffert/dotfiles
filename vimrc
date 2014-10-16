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
Plug 'Lokaltog/vim-easymotion'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'
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
let g:airline_powerline_fonts = 1
let g:airline#themes#base16#constant = 1
let g:airline_theme = g:colors_name == 'solarized' ? 'solarized' : 'base16'

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

"------------------------------------------------------------------------------
" UNITE
"------------------------------------------------------------------------------
if executable("ag")
  let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nocolor --nogroup -S'
  let g:unite_source_grep_recursive_opt = ''
endif

let g:unite_source_history_yank_enable = 1

call unite#custom#source('buffer,file,file_rec/async', 'ignore_globs', split(&wildignore, ','))
call unite#custom#source('file,file/new,buffer,file_rec,file_mru,menu', 'matchers', 'matcher_fuzzy')
call unite#custom#source('menu', 'sorters', 'sorter_reverse')
call unite#custom#source('buffer', 'sorters', 'sorter_reverse')
call unite#custom#profile('files', 'filters', 'sorter_rank')

" settings for buffers
let g:unite_source_buffer_time_format = '(%Y-%m-%d %H:%M:%S) '

call unite#custom#profile('default', 'context', {
\   'winheight': 25,
\   'direction': 'botright',
\   'cursor_line_highlight': 'CursorLine',
\   'update_time': 300,
\ })

" custom mappings for the unite buffer
au FileType unite call <SID>unite_buffer_settings()
function! s:unite_buffer_settings()
  " play nice with supertab
  let b:SuperTabDisabled=1

  " enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j> <Plug>(unite_select_next_line)
  imap <buffer> <C-k> <Plug>(unite_select_previous_line)

  " exit unite
  imap <buffer> <esc> <Plug>(unite_exit)
  nmap <buffer> <esc> <Plug>(unite_exit)
endfunction

nnoremap <silent> <leader>f :<c-u>Unite -start-insert -buffer-name=files file_rec/async<cr>
nnoremap <leader>u :<c-u>Unite<space>

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
