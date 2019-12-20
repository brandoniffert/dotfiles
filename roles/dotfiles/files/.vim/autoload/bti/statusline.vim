function! bti#statusline#modified() abort
  if !&modifiable || &readonly
    return ' [RO]'
  endif

  return &modified && &modifiable ? ' [+]' : ''
endfunction

function! bti#statusline#file_prefix() abort
  let l:basename=expand('%:h')

  if l:basename ==# '' || l:basename ==# '.'
    return ''
  elseif has('modify_fname')
    " Make sure we show $HOME as ~.
    return substitute(fnamemodify(l:basename, ':~:.'), '/$', '', '') . '/'
  else
    " Make sure we show $HOME as ~.
    return substitute(l:basename . '/', '\C^' . $HOME, '~', '')
  endif
endfunction

function! bti#statusline#ft() abort
  return strlen(&filetype) ? &filetype : ''
endfunction

function! bti#statusline#ffenc() abort
  if !empty(&buftype) || empty(bufname('%'))
    return ''
  endif

  let expected_ff = 'unix'
  let expected_fenc = 'utf-8'
  let expected = expected_fenc . ' [' . expected_ff. ']'
  let bomb = &bomb ? '[BOM]' : ''
  let ff = strlen(&fileformat) ? ' [' . &fileformat . ']' : ''

  if expected is# &fileencoding . bomb . ff
    return ''
  else
    return &fileencoding . bomb . ff . ' '
  endif
endfunction

function! bti#statusline#rhs() abort
  let l:rhs = ' '

  if winwidth(0) > 80
    let l:column = virtcol('.')
    let l:width = virtcol('$')
    let l:line = line('.')
    let l:height = line('$')

    " Add padding to stop rhs from changing too much as we move the cursor
    let l:padding = len(l:height) - len(l:line)

    if (l:padding)
      let l:rhs .= repeat(' ', l:padding)
    endif

    let l:rhs .= bti#statusline#ffenc()
    let l:rhs .= 'L '
    let l:rhs .= l:line
    let l:rhs .= '/'
    let l:rhs .= l:height
    let l:rhs .= ' C '
    let l:rhs .= l:column
    let l:rhs .= '/'
    let l:rhs .= l:width
    let l:rhs .= ' '

    " Add padding to stop rhs from changing too much as we move the cursor.
    if len(l:column) < 2
      let l:rhs .= ' '
    endif

    if len(l:width) < 2
      let l:rhs .= ' '
    endif
  endif
  return l:rhs
endfunction

function! bti#statusline#diagonstic_info() abort
  if !exists('*ale#statusline#Count')
    return ''
  endif

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  if l:counts.total == 0
    return ''
  endif

  if l:all_errors != 0 && l:all_non_errors != 0
    return printf('E: %d W: %d', l:all_errors, l:all_non_errors)
  endif

  return l:all_errors == 0 ? printf('W: %d', l:all_non_errors) : printf('E: %d', l:all_errors)
endfunction

function! bti#statusline#whitespace() abort
  let b:statusline_whitespace_check = ''

  if !&modifiable
    return b:statusline_whitespace_check
  endif

  let status = []

  if search('\s$', 'nw') != 0
    call add(status, 'trailing')
  endif

  if search('\v(^\t+ +)|(^ +\t+)', 'nw') != 0
    call add(status, 'mixed')
  endif

  if len(status)
    let b:statusline_whitespace_check = ' ' . join(status, ' · ') . ' '
  endif

  return b:statusline_whitespace_check
endfunction

function! bti#statusline#whitespace_refresh() abort
  if bufname('%') == ''
    return
  endif

  if get(b:, 'statusline_whitespace_changedtick', 0) == b:changedtick
    return
  endif

  unlet! b:statusline_whitespace_changedtick

  let b:statusline_whitespace_changedtick = b:changedtick
endfunction

function! bti#statusline#enable_focus() abort
  let g:enable_statusline_focus = v:true
endfunction

function! bti#statusline#focus() abort
  if exists('g:enable_statusline_focus')
    call s:update_statusline('', 'focus')
  endif
endfunction

function! bti#statusline#blur() abort
  let l:stl = '%<'    " Truncation point
  let l:stl .= '%f\ ' " Filename
  let l:stl .= '%m'   " Modified
  let l:stl .= '%='   " Split left/right halves (makes background cover whole)
  call s:update_statusline(l:stl, 'blur')
endfunction

function! s:update_statusline(default, action) abort
  let l:statusline = s:get_custom_statusline(a:action)

  if type(l:statusline) == type('')
    execute 'setlocal statusline=' . l:statusline
  elseif l:statusline == 0
    return
  else
    execute 'setlocal statusline=' . a:default
  endif
endfunction

function! s:get_custom_statusline(action) abort
  if &ft ==# 'help'
    return
          \ '%<'
          \ . '%1*'
          \ . 'Help'
          \ . '\ -\ '
          \ . '%t'
          \ . '%*'
          \ . '%='
  elseif &ft ==# 'qf'
    return
          \ '%<'
          \ . '%1*'
          \ . '%q'
          \ . '\ '
          \ . '%{get(w:,\"quickfix_title\",\"\")}'
          \ . '%*'
          \ . '%='
  elseif &ft ==# 'Mundo'
    return
          \ '%<'
          \ . '%1*'
          \ . 'Mundo'
          \ . '%*'
          \ . '%='
  elseif &ft ==# 'MundoDiff'
    return
          \ '%<'
          \ . '%1*'
          \ . 'Mundo\ Preview'
          \ . '%*'
          \ . '%='
  elseif &ft ==# 'vim-plug'
    return 0
  elseif &ft ==# 'nerdtree'
    return 0
  endif

  return 1
endfunction
