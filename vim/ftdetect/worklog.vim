augroup worklog
  au!
  au BufNewFile,BufRead *.worklog silent setlocal ft=markdown | setlocal syntax=markdown | setlocal foldmethod=expr foldexpr=getline(v:lnum)=~#'^##'?'>1':'='
augroup END
