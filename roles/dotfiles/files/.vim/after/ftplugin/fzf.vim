setlocal laststatus=0
setlocal noshowmode
setlocal noruler

augroup FZFFileType
  autocmd!
  autocmd BufLeave <buffer> set laststatus=2 ruler
augroup END
