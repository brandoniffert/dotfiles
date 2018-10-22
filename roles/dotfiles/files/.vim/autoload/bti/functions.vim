scriptencoding utf-8

" Replace fancy characters
function! bti#functions#ReplaceFancyCharacters() abort
  let chars = {
    \ '“' : '"',
    \ '”' : '"',
    \ '‘' : "'",
    \ '’' : "'",
    \ '…' : '...'
    \ }

  execute ':%s/'.join(keys(chars), '\|').'/\=chars[submatch(0)]/ge'
endfunction

" Strip whitespace and tabs
function! bti#functions#StripWhitespace() abort
  let saved_winview = winsaveview()
  execute ':%s/\v\s+$//e'
  retab
  call winrestview(saved_winview)
endfunction

" Cycle through number, relativenumber + number, and no numbering
function! bti#functions#CycleLineNumbering() abort
  execute {
        \ '00': 'set norelativenumber | set number',
        \ '10': 'set relativenumber   | set number',
        \ '11': 'set norelativenumber | set nonumber' }[&number . &relativenumber]
endfunction

" Inserts a break (newline) at the current cursor location
function! bti#functions#BreakHere() abort
  execute 's/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6'
  call histdel('/', -1)
endfunction

" Open file in Marked
function! s:preview(file) abort
  silent execute '!open -a "Marked 2.app" ' . shellescape(a:file)
endfunction

function! bti#functions#Preview(...) abort
  if a:0 == 0
    call s:preview(expand('%'))
  else
    for file in a:000
      call s:preview(file)
    endfor
  endif
endfunction

" Create, edit and save files and parent directories
" https://github.com/duggiefresh/vim-easydir
function! bti#functions#CreateAndSaveDirectory() abort
  let s:directory = expand('<afile>:p:h')
  if s:directory !~# '^\(scp\|ftp\|dav\|fetch\|ftp\|http\|rcp\|rsync\|sftp\|file\):' && !isdirectory(s:directory)
    call mkdir(s:directory, 'p')
  endif
endfunction

function! bti#functions#AttemptSelectLastFile() abort
  let previous = expand('#:t')
  if previous !=# ''
    call search('\v<' . previous . '>')
  endif
endfunction
