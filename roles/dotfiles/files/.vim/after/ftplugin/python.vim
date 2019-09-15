setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4

" Run current file
setlocal makeprg=python3\ %

augroup PythonFileType
  autocmd!

  " Automatically format
  autocmd BufWritePre *.py execute ':Black'
augroup END
