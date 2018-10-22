augroup JournalDetect
  autocmd!

  setlocal linebreak noshowcmd

  autocmd FileType markdown.journal execute 'normal! gg'

  autocmd FileType markdown.journal setlocal foldmethod=expr foldexpr=getline(v:lnum)=~#'^##'?'>1':'='

  autocmd FileType markdown.journal nnoremap <silent> <M-k> :call JumpToPrevDate()<cr>zz
  autocmd FileType markdown.journal nnoremap <silent> <M-j> :call JumpToNextDate()<cr>zz

  " If there is no previous date then jump to top of file
  function! JumpToPrevDate()
    execute search('^##\s\d\{4}-\d\{2}-\d\{2}', 'bW')
  endfunction

  function! JumpToNextDate()
    execute search('^##\s\d\{4}-\d\{2}-\d\{2}', 'W')
  endfunction
augroup END
