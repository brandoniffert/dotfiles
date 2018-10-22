augroup btiAutoCommands
  autocmd!

  " Automatically resize vim splits/panes when the window changes size
  autocmd! VimResized * execute "normal! \<c-w>="

  " Don't show line numbers in terminal
  if has('nvim')
    autocmd! TermOpen * setlocal nonumber norelativenumber
  endif

  " Create, edit and save files and parent directories
  autocmd! BufWritePre,FileWritePre * call bti#functions#CreateAndSaveDirectory()

  " When editing a file, always jump to the last known cursor position
  autocmd! BufReadPost *
    \  if line("'\"") > 1 && line("'\"") <= line("$")
    \|   execute 'normal! g`"zvzz'
    \| endif
    noh
augroup END
