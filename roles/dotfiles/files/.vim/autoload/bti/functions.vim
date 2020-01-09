" Replace fancy characters
function! bti#functions#replace_fancy_characters() abort
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
function! bti#functions#strip_whitespace() abort
  let saved_winview = winsaveview()
  execute ':%s/\v\s+$//e'
  retab
  call winrestview(saved_winview)
endfunction

" Cycle through number, relativenumber + number, and no numbering
function! bti#functions#cycle_line_numbering() abort
  execute {
        \ '00': 'set norelativenumber | set number',
        \ '01': 'set norelativenumber | set number',
        \ '10': 'set relativenumber   | set number',
        \ '11': 'set norelativenumber | set nonumber' }[&number . &relativenumber]
endfunction

" Inserts a break (newline) at the current cursor location
function! bti#functions#break_here() abort
  execute 's/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6'
  call histdel('/', -1)
endfunction

" Open file in Marked
function! s:preview(file) abort
  silent execute '!open -a "Marked 2.app" ' . shellescape(a:file)
endfunction

function! bti#functions#preview(...) abort
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
function! bti#functions#create_and_save_directory() abort
  let s:directory = expand('<afile>:p:h')
  if s:directory !~# '^\(scp\|ftp\|dav\|fetch\|ftp\|http\|rcp\|rsync\|sftp\|file\):' && !isdirectory(s:directory)
    call mkdir(s:directory, 'p')
  endif
endfunction

function! bti#functions#attempt_select_last_file() abort
  let previous = expand('#:t')
  if previous !=# ''
    call search('\v<' . previous . '>')
  endif
endfunction

" We want to control what types of files will allow for focus/blur effect
function! bti#functions#should_allow_focus() abort
  let s:bti_should_allow_focus_blacklist = ['diff', 'qf', 'nerdtree', 'help', 'vim-plug', 'Mundo', 'MundoDiff']

  return !empty(&filetype) && index(s:bti_should_allow_focus_blacklist, &filetype) == -1
endfunction

" Focus the window
function! bti#functions#focus_window() abort
  if bti#functions#should_allow_focus()
    setlocal cursorline
  endif
endfunction

" Blur the window
function! bti#functions#blur_window() abort
  if bti#functions#should_allow_focus()
    setlocal nocursorline
  endif
endfunction

function! bti#functions#extend_highlight(base, group, add) abort
  redir => base_hi
  silent! execute 'highlight' a:base
  redir END
  let group_hi = split(base_hi, '\n')[0]
  let group_hi = substitute(group_hi, '^'.a:base.'\s\+xxx', '', '')
  sil exe 'highlight' a:group group_hi a:add
endfunction
