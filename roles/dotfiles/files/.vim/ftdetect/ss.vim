augroup SilverStripeTemplateDetect
  autocmd!
  autocmd BufEnter,BufRead,BufNewFile *.ss
        \ set filetype=ss.html syntax=ss |
        \ runtime! ftplugin/ss.vim |
        \ runtime! indent/ss.vim
augroup END
