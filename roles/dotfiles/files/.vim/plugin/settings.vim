scriptencoding utf-8

set autoindent
set backspace=indent,start,eol
set belloff=all

if !empty('$TMUX')
  set cmdheight=2
endif

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
set laststatus=2
set lazyredraw
set linebreak
set list
set listchars=tab:>-
set listchars+=trail:.
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⦸
set mouse=a
set nojoinspaces
set noshowcmd
set noshowmode
set scrolloff=3
set shiftwidth=2
let &showbreak = '↳ '
set relativenumber
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
set termguicolors
set updatetime=500
set wildmode=longest:full,full
set wildignore+=.git,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.sw?,*.DS_Store,*.pyc.*/tmp/*,*.so

" Backups
if exists('$SUDO_USER')
  set nobackup
  set nowritebackup
else
  if !has('nvim')
    set backupdir=~/.vim/tmp/backup//
    set backupdir+=.
  endif
endif

" Swapfile
if exists('$SUDO_USER')
  set noswapfile
else
  if !has('nvim')
    set directory=~/.vim/tmp/swap//
    set directory+=.
  endif
endif

" Undo
if has('persistent_undo')
  if exists('$SUDO_USER')
    set noundofile
  else
    if !has('nvim')
      set undodir=~/.vim/tmp/undo//
      set undodir+=.
    endif

    set undofile
  endif
endif

" viminfo
if has('viminfo')
  if exists('$SUDO_USER')
    set viminfo=
  else
    if !has('nvim')
      set viminfo+=n~/.vim/tmp/viminfo

      if !empty(glob('~/.vim/tmp/viminfo'))
        if !filereadable(expand('~/.vim/tmp/viminfo'))
          echoerr 'warning: ~/.vim/tmp/viminfo exists but is not readable'
        endif
      endif
    endif
  endif
endif
