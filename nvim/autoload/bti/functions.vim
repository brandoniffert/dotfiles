scriptencoding utf-8

" Replace fancy characters
function! bti#functions#replace_fancy_characters() abort
  let l:chars = {
    \ '“' : '"',
    \ '”' : '"',
    \ '‘' : "'",
    \ '’' : "'",
    \ '…' : '...'
    \ }

  execute ':%s/'.join(keys(l:chars), '\|').'/\=chars[submatch(0)]/ge'
endfunction

" Strip whitespace and tabs
function! bti#functions#strip_whitespace() abort
  let l:saved_winview = winsaveview()
  execute ':%s/\v\s+$//e'
  retab
  call winrestview(l:saved_winview)
endfunction

" Inserts a break (newline) at the current cursor location
function! bti#functions#break_here() abort
  execute 's/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6'
  call histdel('/', -1)
endfunction
