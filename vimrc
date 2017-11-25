"-------------------------------------------------------------------------------
" This is the vimrc file I use on remote machines
" Author: Brandon Iffert <brandoniffert@gmail.com>
" Source: https://github.com/brandoniffert/dotfiles/blob/master/vimrc
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" GENERAL SETTINGS
"-------------------------------------------------------------------------------
set clipboard=
set dictionary+=/usr/share/dict/words
set fileformats+=mac
set foldlevelstart=0                  " close folds by default
set foldmethod=marker
set formatoptions=qrn1j
set hidden                            " keep buffers around
set mouse=
set nojoinspaces                      " only one space after joining lines
set notimeout ttimeout ttimeoutlen=10
set nrformats-=octal                  " allow incrementing 001 to 002 with <C-a>
set number
set scrolloff=3
set shell=/bin/bash
set showcmd
set splitbelow splitright             " put new windows to bottom/right
set switchbuf+=useopen
set textwidth=80
set ttyfast

" Set custom spellfile
if filereadable(expand("~/.vim-custom.en.utf8.add"))
  set spellfile=~/.vim-custom.en.utf8.add
endif

" Tabs & Indenting
set smartindent
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set shiftround

" No backups or swap file
set nobackup nowritebackup noswapfile

" Wildmenu
set wildmode=longest,list
set wildignore+=.git,.svn,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.sw?,*.DS_Store,*.pyc.*/tmp/*,*.so,*.zip

" Show invisible characters
set list
let &listchars="tab:>-,trail:.,extends:>,precedes:<,nbsp:\u00b7"

" Searching
set showmatch incsearch hlsearch ignorecase smartcase

" Remap leader
let mapleader="\<space>"

"------------------------------------------------------------------------------
" STATUSLINE
"------------------------------------------------------------------------------
set statusline=                           " reset
set statusline+=[%n]                      " buffer number
set statusline+=\ %f                      " file path
set statusline+=\ (%{&filetype})          " file type
set statusline+=\ %m%r%w%h                " modified/read-only/preview/help
set statusline+=%=                        " left/right separator
set statusline+=%{&fileformat}\ \|        " file format
set statusline+=\ %{&fileencoding}\ \|    " file encoding
set statusline+=\ %l\/%L:%c\              " line/column number

"-------------------------------------------------------------------------------
" ENVIRONMENTS AND COLOR
"-------------------------------------------------------------------------------
syntax enable
set bg=dark
colorscheme spacegray
hi Normal ctermbg=NONE

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

"-------------------------------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------------------------------
augroup bti-vimrc
  au!
  au! VimResized * wincmd =

  " When editing a file, always jump to the last known cursor position.
  au! BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

"------------------------------------------------------------------------------
" CUSTOM COMMANDS
"------------------------------------------------------------------------------
" Replace fancy characters
function! ReplaceFancyCharacters()
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
function! StripWhitespace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  retab
  call cursor(l, c)
endfunction
command! StripWhitespace call StripWhitespace()
