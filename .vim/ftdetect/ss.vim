augroup silverstripe-templates
  au!
  au BufEnter,BufRead,BufNewFile *.ss silent set ft=html.ss
  au BufEnter *.ss :syntax sync fromstart
augroup END
