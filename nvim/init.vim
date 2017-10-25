"-------------------------------------------------------------------------------
" This is my nvim init file - it changes often
" Author: Brandon Iffert <brandoniffert@gmail.com>
" Source: https://github.com/brandoniffert/dotfiles/blob/master/nvim/init.vim
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" SETUP
"-------------------------------------------------------------------------------
au!

" Bootstrap vim-plug on a fresh install
if !filereadable(expand("~/.config/nvim/autoload/plug.vim"))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrap=1
endif

call plug#begin()
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'ervandew/supertab'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }
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
Plug 'w0rp/ale'
call plug#end()

if exists("s:bootstrap") && s:bootstrap
  unlet s:bootstrap
  PlugInstall
endif

" Setup yankstack before any other configurations
call yankstack#setup()

"-------------------------------------------------------------------------------
" GENERAL SETTINGS
"-------------------------------------------------------------------------------
set clipboard=
set dictionary+=/usr/share/dict/words
set dictionary+=/usr/share/dict/web2a
set dictionary+=/usr/share/dict/propernames
set dictionary+=/usr/share/dict/connectives
set fileformats+=mac
set foldlevelstart=0
set foldmethod=marker
set formatoptions+=qrn1j
set hidden
set lazyredraw
set linebreak
set nojoinspaces
set noshowmode
set number relativenumber
set ruler
set scrolloff=3
set shell=/usr/local/bin/zsh
set showcmd
set splitbelow splitright
set switchbuf+=useopen
set termguicolors
set undofile

" Set custom spellfile
if filereadable(expand('~/.vim-custom.en.utf8.add'))
  set spellfile=~/.vim-custom.en.utf8.add
endif

" Tabs
set expandtab tabstop=2 shiftwidth=2 softtabstop=2

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
set showmatch ignorecase smartcase

" Remap leader
let mapleader="\<space>"

"-------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"-------------------------------------------------------------------------------
augroup nord-overrides
  autocmd!
  autocmd ColorScheme nord highlight Normal guibg=#20242c
  autocmd ColorScheme nord highlight LineNr guibg=#20242c
  autocmd ColorScheme nord highlight CursorLineNr guibg=#20242c
  autocmd ColorScheme nord highlight Folded guifg=#7b88a1
  autocmd ColorScheme nord highlight diffAdded guifg=#A3BE8C
  autocmd ColorScheme nord highlight diffRemoved guifg=#BF616A
augroup END

let g:nord_comment_brightness = 5
colorscheme nord

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

" Clear the highlighted search
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

" Run current file using makeprg
nnoremap <leader>r :make!<cr>

" Terminal mode mappings
tnoremap <leader><esc> <c-\><c-n>
tnoremap <leader><c-h> <c-\><c-n><c-w>h
tnoremap <leader><c-j> <c-\><c-n><c-w>j
tnoremap <leader><c-k> <c-\><c-n><c-w>k
tnoremap <leader><c-l> <c-\><c-n><c-w>l

"-------------------------------------------------------------------------------
" PLUGINS
"-------------------------------------------------------------------------------
" Vim test
nnoremap <silent><leader>t :TestFile<CR>

" ALE
let g:ale_lint_on_text_changed = 'never'
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {
\   'html': [],
\}

" Limelight
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Ripgrep
set grepprg=rg\ --vimgrep

" FZF
let g:fzf_layout = { 'down': '~20%' }

nnoremap <silent><leader>f :Files<cr>
nnoremap <silent><leader>b :Buffers<cr>

function! s:fzf_statusline()
  highlight fzf1 guibg=#3B4252
  setlocal statusline=%#fzf1#\ >\ fzf
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --vimgrep --smart-case --color=always --colors=path:fg:white --colors=line:none '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"-------------------------------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------------------------------
augroup bti-vimrc
  au!
  au! VimResized * wincmd =

  au! WinEnter term://* startinsert

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
