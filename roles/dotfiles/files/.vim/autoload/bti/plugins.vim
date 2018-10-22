let s:CURRENT_FILE = expand('<sfile>')

function! bti#plugins#LoadPlugins() abort
  call plug#begin()
  Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'ervandew/supertab'
  Plug 'itchyny/lightline.vim'
  Plug 'janko-m/vim-test'
  Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
  Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }
  Plug 'junegunn/vim-peekaboo'
  Plug 'justinmk/vim-sneak'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'machakann/vim-sandwich'
  Plug 'mhinz/vim-signify'
  Plug 'sheerun/vim-polyglot'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
  Plug 'simnalamburt/vim-mundo', { 'on': 'MundoShow' }
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'unblevable/quick-scope'
  Plug 'w0rp/ale'
  Plug 'wincent/loupe'
  Plug 'wincent/terminus'
  Plug 'Yggdroot/indentLine'

  if executable('fzf')
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'
  endif

  if executable('composer')
    Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}
  endif
  call plug#end()
endfunction

function! bti#plugins#Init() abort
  " Bootstrap vim-plug on a fresh install - require a manual PlugInstall
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    call bti#plugins#LoadPlugins()
  endif
endfunction

command! ReloadPlugins execute 'source ' . s:CURRENT_FILE | call bti#plugins#LoadPlugins()
