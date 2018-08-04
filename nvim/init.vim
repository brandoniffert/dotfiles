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
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'henrik/vim-indexed-search'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }
Plug 'junegunn/vim-easy-align'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'machakann/vim-sandwich'
Plug 'mhinz/vim-signify'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
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
set fileencoding=utf8
set foldlevelstart=0
set foldmethod=marker
set formatoptions+=qrn1j
set hidden
set lazyredraw
set linebreak
set nojoinspaces
set noshowmode
set noswapfile
set number relativenumber
set ruler
set scrolloff=3
set showcmd
set splitbelow splitright
set switchbuf+=useopen
set termguicolors
set undofile
set updatetime=500

if !empty($TMUX)
  set cmdheight=2
endif

" Set custom spellfile
if filereadable(expand('~/.vim-custom.en.utf8.add'))
  set spellfile=~/.vim-custom.en.utf8.add
endif

" Tabs
set expandtab shiftwidth=2 softtabstop=2

" Wildmenu
set wildmode=longest,list
set wildignore+=.svn,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.sw?,*.DS_Store,*.pyc.*/tmp/*,*.so,*.zip

" Show invisible characters
set list
let &listchars="tab:>-,trail:.,extends:>,precedes:<,nbsp:\u00b7"

" Fillchars
set fillchars=vert:│,fold:-

" Searching
set showmatch ignorecase smartcase

" Remap leader
let mapleader="\<space>"

"-------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"-------------------------------------------------------------------------------
augroup nord-overrides
  autocmd!
  autocmd ColorScheme nord highlight! Normal guibg=NONE
  autocmd ColorScheme nord highlight! CursorLine guibg=#2B303B
  autocmd ColorScheme nord highlight! Error guifg=#D8DEE9
  autocmd ColorScheme nord highlight! Folded guifg=#7b88a1
  autocmd ColorScheme nord highlight! LineNr guifg=#2E3440 guibg=NONE
  autocmd ColorScheme nord highlight! SignColumn guibg=NONE
  autocmd ColorScheme nord highlight! TabLine guibg=#2E3440
  autocmd ColorScheme nord highlight! TabLineFill guibg=#2E3440
  autocmd ColorScheme nord highlight! TabLineSel guifg=#A3BE8C guibg=#3B4252
  autocmd ColorScheme nord highlight! VertSplit guibg=NONE
  autocmd ColorScheme nord highlight! Visual guibg=#2E3440
  autocmd ColorScheme nord highlight! link CursorLineNr LineNr
  autocmd ColorScheme nord highlight! link jsObjectKey jsonKeyword
augroup END

let g:nord_comment_brightness = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
colorscheme nord

" Airline
let g:airline_theme = 'bti_nord'
let g:airline_symbols_ascii = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#wordcount#enabled = 0
let g:airline_section_x = ''

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

"-------------------------------------------------------------------------------
" KEY MAPS
"-------------------------------------------------------------------------------
" Navigate over wrapped lines
nnoremap j gj
nnoremap k gk

" Clear the highlighted search
nnoremap <silent><cr> :noh<cr>

" Enter command mode
nnoremap <leader><cr> :
vnoremap <leader><cr> :

" Use hjkl for switching between splits
nnoremap <c-j> <c-W>j
nnoremap <c-h> <c-W>h
nnoremap <c-k> <c-W>k
nnoremap <c-l> <c-W>l

" Use arrow keys for tab navigation
nnoremap <left> :tabp<cr>
nnoremap <right> :tabn<cr>

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

" Open new horizontal/vertical split
nnoremap <silent><leader>s :new<cr>
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

nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)

" Limelight
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" EasyMotion
map <leader>m <Plug>(easymotion-prefix)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)

" Ripgrep
set grepprg=rg\ --vimgrep\ $*
set grepformat=%f:%l:%m

" Vim markdown
let g:vim_markdown_conceal = 0

" Signify
let g:signify_vcs_list = ['git']

" NERDTree
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

" FZF
let g:fzf_layout = { 'down': '~30%' }

nnoremap <silent><leader>f :Files<cr>
nnoremap <silent><leader>b :Buffers<cr>

function! s:fzf_statusline() abort
  highlight fzf1 guibg=#2E3440
  setlocal statusline=%#fzf1#\ >\ fzf
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

if executable('rg')
  function! s:rg_with_opts(arg, bang)
    let rg_cmd = 'rg --line-number --smart-case --color=always --colors=path:fg:green --colors=line:fg:blue '
    let tokens = split(a:arg)
    let rg_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
    let query = join(filter(copy(tokens), 'v:val !~ "^-"'))
    let cmd = rg_cmd . rg_opts . ' ' . shellescape(query)
    let preview_type = a:bang ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?')

    return call('fzf#vim#grep', [cmd, 0, preview_type])
  endfunction

  command! -bang -nargs=* G call s:rg_with_opts(<q-args>, <bang>0)
  nnoremap <leader>a :G<space>
endif

"-------------------------------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------------------------------
augroup bti-vimrc
  autocmd!
  autocmd! VimResized * wincmd =

  " Don't show line numbers in terminal
  autocmd! TermOpen * setlocal nonumber norelativenumber

  " Always highlight shebang-looking lines as Comment
  autocmd! BufEnter,WinEnter * call matchadd("Comment", "^#!\/.*", -1)

  " Handle crontab editing
  autocmd! filetype crontab setlocal nobackup nowritebackup

  " When editing a file, always jump to the last known cursor position
  autocmd! BufReadPost *
    \  if line("'\"") > 1 && line("'\"") <= line("$")
    \|   exe 'normal! g`"zvzz'
    \| endif
    noh
augroup END

"------------------------------------------------------------------------------
" CUSTOM COMMANDS
"------------------------------------------------------------------------------
" Replace fancy characters
function! ReplaceFancyCharacters() abort
  let chars = {
    \ "“" : '"',
    \ "”" : '"',
    \ "‘" : "'",
    \ "’" : "'",
    \ "–" : '--',
    \ "—" : '---',
    \ "…" : '...'
    \ }
  exec ":%s/".join(keys(chars), '\|').'/\=chars[submatch(0)]/ge'
endfunction
command! ReplaceFancyCharacters call ReplaceFancyCharacters()

" Strip whitespace and tabs
function! StripWhitespace() abort
  let l:saved_winview = winsaveview()
  %s/\v\s+$//e
  retab
  call winrestview(l:saved_winview)
endfunction
command! StripWhitespace call StripWhitespace()
