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

" Create, edit and save files and parent directories
" https://github.com/duggiefresh/vim-easydir
function! bti#functions#create_and_save_directory() abort
  let l:directory = expand('<afile>:p:h')
  if l:directory !~# '^\(scp\|ftp\|dav\|fetch\|ftp\|http\|rcp\|rsync\|sftp\|file\):' && !isdirectory(l:directory)
    call mkdir(l:directory, 'p')
  endif
endfunction

" We want to control what types of files will allow for focus/blur effect
function! bti#functions#should_allow_focus() abort
  let l:bti_should_allow_focus_blacklist = ['diff']

  return index(l:bti_should_allow_focus_blacklist, &filetype) == -1
endfunction

" Focus the window
function! bti#functions#focus_window() abort
  if bti#functions#should_allow_focus()
    if !empty(&filetype)
      let l:settings=s:get_spell_settings()
      ownsyntax on
      setlocal cursorline
      call s:set_spell_settings(l:settings)
    endif

    if has('nvim') && exists('g:bti_enable_window_focus')
      set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
    endif
  endif
endfunction

" Blur the window
function! bti#functions#blur_window() abort
  if bti#functions#should_allow_focus()
    if !empty(&filetype)
      let l:settings=s:get_spell_settings()
      ownsyntax off
      setlocal nocursorline
      call s:set_spell_settings(l:settings)
    endif

    if has('nvim')
      set winhighlight=Normal:InactiveWindow,NormalNC:InactiveWindow

      if !exists('g:bti_enable_window_focus')
        let g:bti_enable_window_focus = v:true
      endif
    endif
  endif
endfunction

" Extend a highlight group by resetting it with additional attributes
function! bti#functions#extend_highlight(base, group, add) abort
  redir => l:base_hi
  silent! execute 'highlight' a:base
  redir END
  let l:group_hi = split(l:base_hi, '\n')[0]
  let l:group_hi = substitute(l:group_hi, '^'.a:base.'\s\+xxx', '', '')
  silent execute 'highlight' a:group group_hi a:add
endfunction
