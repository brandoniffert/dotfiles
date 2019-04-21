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

  " Temporary fix for broken bracketed paste
  " https://github.com/neovim/neovim/issues/7994#issuecomment-388296360
  autocmd! InsertLeave * set nopaste

  " Allow focusing/bluring effect for a window
  autocmd BufEnter,FocusGained,VimEnter,WinEnter * call bti#functions#FocusWindow()
  autocmd FocusLost,WinLeave * call bti#functions#BlurWindow()

  " When editing a file, always jump to the last known cursor position
  autocmd! BufReadPost *
    \  if line("'\"") > 1 && line("'\"") <= line("$")
    \|   execute 'normal! g`"zvzz'
    \| endif
    noh
augroup END
