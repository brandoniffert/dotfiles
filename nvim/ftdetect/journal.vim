augroup journal
  au!
  setlocal linebreak noshowcmd

  au FileType markdown.journal exe "normal! gg"

  au FileType markdown.journal let g:limelight_bop = '^##'
  au FileType markdown.journal let g:limelight_eop = '\s*\n##'

  au FileType markdown.journal nnoremap <silent> <M-k> :call JumpToPrevDate()<cr>
  au FileType markdown.journal nnoremap <silent> <M-j> :call search('^##\s\d\{4}-\d\{2}-\d\{2}', 'W')<cr>

  " If there is no previous date then jump to top of file
  function! JumpToPrevDate()
    execute search('^##\s\d\{4}-\d\{2}-\d\{2}', 'bW')
  endfunction
augroup END
