scriptencoding utf-8

" vim: foldlevel=0
"
"-------------------------------------------------------------------------------
" vimrc
"-------------------------------------------------------------------------------

" Providers {{{

" python3
if filereadable($HOME . '/.local/share/pyenv/versions/py3nvim/bin/python')
  let g:python3_host_prog = $HOME . '/.local/share/pyenv/versions/py3nvim/bin/python'
endif

" nodejs
if filereadable('/usr/local/bin/neovim-node-host')
  let g:node_host_prog = '/usr/local/bin/neovim-node-host'
endif

" Disable unused providers
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" }}}

" Color {{{

augroup btiColorScheme
  autocmd!
  autocmd ColorScheme * call bti#functions#extend_highlight('StatusLine', 'User1', 'guifg=white gui=bold')
  autocmd ColorScheme * call bti#functions#extend_highlight('StatusLine', 'User2', 'gui=italic')
augroup END

" Set vim-specific sequences for RGB colors
if !has('nvim')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set termguicolors
colorscheme nordish

" }}}

" Plugins {{{

" Bootstrap vim-plug on a fresh install - require a manual PlugInstall
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

let g:polyglot_disabled = ['sensible', 'autoindent']

call plug#begin()
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'janko-m/vim-test', { 'on': ['TestFile', 'TestNearest'] }
Plug 'machakann/vim-sandwich'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo', { 'on': 'MundoShow' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'unblevable/quick-scope'
Plug 'wincent/loupe'
Plug 'wincent/terminus'

if executable('fzf')
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
endif

if executable('composer')
  Plug 'phpactor/phpactor', { 'for': 'php', 'do': 'composer install' }
endif

" Leave this so PlugClean doesn't remove it, but also doesn't load it
Plug 'lifepillar/vim-colortemplate', { 'on': [] }

" Uncomment to work with vim-colortemplate
" Plug 'lifepillar/vim-colortemplate'
call plug#end()

" }}}

" General Settings {{{

set autoindent
set backspace=indent,start,eol
set belloff=all
set completeopt=menu,menuone,preview
set expandtab
let &fillchars = 'vert:│,fold:·,eob: '
set foldlevelstart=0
set foldmethod=marker
set formatoptions+=qrn1j
set grepformat=%f:%l:%m

if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
endif

set hidden
set ignorecase
set lazyredraw
set linebreak
set list
set listchars=tab:▷-
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⦸
set mouse=a
set number
set nojoinspaces
set noshowcmd
set noshowmode
set scrolloff=3
set shiftwidth=2
let &showbreak = '↳ '
set relativenumber
set shortmess+=c
set showmatch
set signcolumn=yes
set smartcase
set smarttab
set softtabstop=2
set spellcapcheck=

if filereadable(expand('~/.vim/spell/en.utf-8.add'))
  set spellfile=~/.vim/spell/en.utf-8.add
endif

set splitbelow
set splitright
set switchbuf+=useopen
set undofile
set updatetime=300
set wildmode=longest:full,full
set wildignore+=.git,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.sw?,*.DS_Store,*.pyc.*/tmp/*,*.so

let g:netrw_dirhistmax = 0

" Tabline
if has('windows')
  set tabline=%!bti#tabline#line()
endif

" Backups, swapfiles, undo, viminfo
if exists('$SUDO_USER')
  set nobackup
  set nowritebackup
  set noswapfile
  set noundofile

  if !has('nvim')
    set viminfo=
  endif
else
  if !has('nvim')
    if !isdirectory($XDG_CACHE_HOME . '/vim')
      call mkdir($XDG_CACHE_HOME . '/vim/backup', 'p')
      call mkdir($XDG_CACHE_HOME . '/vim/swap', 'p')
      call mkdir($XDG_CACHE_HOME . '/vim/undo', 'p')
    endif

    set backupdir=$XDG_CACHE_HOME/vim/backup//
    set backupdir+=.

    set directory=$XDG_CACHE_HOME/vim/swap//
    set directory+=.

    set undodir=$XDG_CACHE_HOME/vim/undo//
    set undodir+=.

    set viminfo+=n$XDG_CACHE_HOME/vim/viminfo

    if !empty(glob($XDG_CACHE_HOME . '/vim/viminfo'))
      if !filereadable(expand($XDG_CACHE_HOME . '/vim/viminfo'))
        echoerr 'Warning: $XDG_CACHE_HOME/vim/viminfo exists but is not readable'
      endif
    endif
  endif
endif

" }}}

" Mappings {{{

" Remap leaders
let mapleader = "\<space>"
let maplocalleader = ','

" Navigate over wrapped lines
nnoremap j gj
nnoremap k gk

" Enter command mode
nnoremap <leader><cr> :
vnoremap <leader><cr> :

" Use hjkl for switching between splits
nnoremap <c-h> <c-W>h
nnoremap <c-j> <c-W>j
nnoremap <c-k> <c-W>k
nnoremap <c-l> <c-W>l

" Use arrow keys for tab navigation
nnoremap <left> :tabp<cr>
nnoremap <right> :tabn<cr>

" Select text that was just pasted
nnoremap <leader>gv V`]

" Quick jump back and forth between files
nnoremap <silent> <leader><leader> :<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<cr>

" Quick quit
nnoremap <silent> <leader>q :quit<cr>
nnoremap <silent> <leader>Q :quitall<cr>

" Easy indent/outdent
nnoremap <tab> >>
nnoremap <s-tab> <<
vnoremap <tab> >gv
vnoremap <s-tab> <gv

" Make S split lines (opposite of J)
nnoremap <silent> S :<c-u>call bti#functions#break_here()<cr>

" Open new horizontal/vertical split
nnoremap <silent> <leader>v :vnew<cr>

" Yank/paste using system clipboard
vnoremap <leader>y "*y
nnoremap <leader>p "*p

" Don't replace register with text that was pasted over
xnoremap <silent> p p:if v:register == '"'<bar>let @@=@0<bar>endif<cr>

" Make Y act like other capital letters
nnoremap Y y$

" Run current file using makeprg
nnoremap <leader>r :make!<cr>

" Cycle line numbering
noremap <silent> <f3> :call bti#functions#cycle_line_numbering()<cr>

" Strip whitespace
nnoremap <silent> <localleader>zz :call bti#functions#strip_whitespace()<cr>

" Fix (most) syntax highlighting problems in current buffer
nnoremap <silent> <localleader>c :syntax sync fromstart<cr>

" Edit file, starting in same directory as current file
nnoremap <localleader>e :edit <C-R>=expand('%:p:h') . '/'<cr>

" Get syntax highlight group of item under the cursor
nnoremap <localleader>h :call <sid>syn_stack()<cr>
function! <sid>syn_stack() abort
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" Write file with sudo
if !has('nvim')
  cnoremap w!! execute 'write !sudo tee % >/dev/null' <bar> edit!
endif


" Terminal mode mappings
if exists(':tnoremap')
  tnoremap <leader><esc> <c-\><c-n>
  tnoremap <leader><c-h> <c-\><c-n><c-w>h
  tnoremap <leader><c-j> <c-\><c-n><c-w>j
  tnoremap <leader><c-k> <c-\><c-n><c-w>k
  tnoremap <leader><c-l> <c-\><c-n><c-w>l
endif

" }}}

" Statusline {{{

set laststatus=2

set statusline=
set statusline+=%<                                  " Truncation point
set statusline+=%{bti#statusline#file_prefix()}     " Relative path excluding filename
set statusline+=%1*                                 " Bold
set statusline+=%t                                  " Filename
set statusline+=%{bti#statusline#readonly()}        " Readonly
set statusline+=%*                                  " Reset highlight group
set statusline+=%#ErrorMsg#                         " Red
set statusline+=%{bti#statusline#modified()}        " Modified
set statusline+=%*                                  " Reset highlight group
set statusline+=\                                   " Space
set statusline+=%((%2*%{bti#statusline#ft()}%*)%)   " File type in italics
set statusline+=%=                                  " Split point for left and right groups
set statusline+=%{bti#statusline#rhs()}             " File encoding and line/column info
set statusline+=%#WildMenu#                         " White/Black highlight
set statusline+=%{bti#statusline#whitespace()}      " Whitespace indicator
set statusline+=%*                                  " Reset highlight group
set statusline+=%#WarningMsg#                       " Yellow/Black highlight
set statusline+=%{bti#statusline#diagonstic_info()} " Diagnostic info
set statusline+=%*                                  " Reset highlight group

augroup btiStatusline
  autocmd!
  autocmd CursorHold,BufWritePost * call bti#statusline#whitespace_refresh()

  autocmd BufEnter,FocusGained,WinEnter * call bti#statusline#focus()
  autocmd FocusLost,WinLeave * call bti#statusline#blur()
augroup END

" }}}

" Autocommands {{{

augroup btiAutocommands
  autocmd!

  " Automatically resize vim splits/panes when the window changes size
  autocmd! VimResized * execute "normal! \<c-w>="

  " Don't show line numbers in terminal
  if has('nvim')
    autocmd! TermOpen * setlocal nonumber norelativenumber
  endif

  " Create, edit and save files and parent directories
  autocmd! BufWritePre,FileWritePre * call bti#functions#create_and_save_directory()

  " Auto close preview window
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

  " Allow focusing/bluring effect for a window
  autocmd BufEnter,FocusGained,VimEnter,WinEnter * call bti#functions#focus_window()
  autocmd FocusLost,WinLeave * call bti#functions#blur_window()

  " Set zsh filetype if editing a zsh function buffer
  autocmd BufRead,BufNewFile */zsh/functions/** set filetype=zsh

  " When editing a file, always jump to the last known cursor position
  autocmd! BufReadPost *
    \  if line("'\"") > 1 && line("'\"") <= line("$")
    \|   execute 'normal! g`"zvzz'
    \| endif
    noh
augroup END

" }}}

" Commands {{{

command! ReplaceFancyCharacters call bti#functions#replace_fancy_characters()
command! StripWhitespace call bti#functions#strip_whitespace()
command! -nargs=* -complete=file Preview call bti#functions#preview(<f-args>)

" }}}
