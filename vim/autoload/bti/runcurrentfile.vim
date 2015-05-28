"------------------------------------------------------------------------------
" RUN CURRENT FILE
"------------------------------------------------------------------------------
function! bti#runcurrentfile#run()
  let l:types = {
        \ 'ruby' : 'ruby',
        \ 'php' : 'php -f',
        \ 'python' : 'python3',
        \ 'sh' : 'bash'
        \ }
  exec "w"
  if has_key(l:types, &ft)
    exec "!" . l:types[&ft] . " " . expand("%")
  else
    echo "Unrecognized run filetype command!"
  endif
endfunction
