augroup journal
  au!
  setlocal linebreak noshowcmd

  au FileType markdown.journal exe "normal! gg"

  au FileType markdown.journal setlocal foldmethod=expr foldexpr=getline(v:lnum)=~#'^##'?'>1':'='

  au FileType markdown.journal nnoremap <silent> <M-k> :call JumpToPrevDate()<cr>zz
  au FileType markdown.journal nnoremap <silent> <M-j> :call JumpToNextDate()<cr>zz

  " If there is no previous date then jump to top of file
  function! JumpToPrevDate()
    execute search('^##\s\d\{4}-\d\{2}-\d\{2}', 'bW')
  endfunction

  function! JumpToNextDate()
    execute search('^##\s\d\{4}-\d\{2}-\d\{2}', 'W')
  endfunction
augroup END
