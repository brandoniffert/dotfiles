augroup btiColorScheme
  autocmd!
  autocmd ColorScheme nordish call bti#functions#extend_highlight('StatusLine', 'User1', 'guifg=#E5E9F0 gui=bold')
  autocmd ColorScheme nordish call bti#functions#extend_highlight('StatusLine', 'User2', 'gui=italic')
augroup END

" Set vim-specific sequences for RGB colors
if !has('nvim')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set bg=dark
set termguicolors
colorscheme nordish
