"------------------------------------------------------------------------------
" STRIP WHITESPACE & TABS
"------------------------------------------------------------------------------
function! bti#whitespace#strip()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  retab
  call cursor(l, c)
endfunction
