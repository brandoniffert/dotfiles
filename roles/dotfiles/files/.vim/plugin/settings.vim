scriptencoding utf-8

" General settings
set clipboard=
set dictionary+=/usr/share/dict/words
set dictionary+=/usr/share/dict/web2a
set dictionary+=/usr/share/dict/propernames
set dictionary+=/usr/share/dict/connectives
set foldlevelstart=0
set foldmethod=marker
set formatoptions+=qrn1j
set hidden
set laststatus=2
set lazyredraw
set linebreak
set mouse=a
set nojoinspaces
set noshowmode
set nonumber
set ruler
set scrolloff=3
let &showbreak = '» '
set showcmd
set spellcapcheck=
set splitbelow
set splitright
set switchbuf+=useopen
set termguicolors
set updatetime=500

if !empty('$TMUX')
  set cmdheight=2
endif

" Set custom spellfile
if filereadable(expand('~/.vim/spell/en.utf-8.add'))
  set spellfile=~/.vim/spell/en.utf-8.add
endif

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2

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
set showmatch
set ignorecase
set smartcase

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

" Set grepprg to use ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
  set grepformat=%f:%l:%m
endif
