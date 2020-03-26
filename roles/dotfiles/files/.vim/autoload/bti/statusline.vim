scriptencoding utf-8

function! bti#statusline#modified() abort
  return &modified && &modifiable ? ' ✕' : ''
endfunction

function! bti#statusline#readonly() abort
  return !&modifiable || &readonly ? ' [RO]' : ''
endfunction

function! bti#statusline#file_prefix() abort
  let l:basename=expand('%:h')

  if basename ==# '' || basename ==# '.'
    return ''
  elseif has('modify_fname')
    " Make sure we show $HOME as ~.
    return substitute(fnamemodify(basename, ':~:.'), '/$', '', '') . '/'
  else
    " Make sure we show $HOME as ~.
    return substitute(basename . '/', '\C^' . $HOME, '~', '')
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
    let l:padding = len(height) - len(line)

    if (padding)
      let l:rhs .= repeat(' ', padding)
    endif

    let l:rhs .= bti#statusline#ffenc()
    let l:rhs .= 'L '
    let l:rhs .= line
    let l:rhs .= '/'
    let l:rhs .= height
    let l:rhs .= ' C '
    let l:rhs .= column
    let l:rhs .= '/'
    let l:rhs .= width
    let l:rhs .= ' '

    " Add padding to stop rhs from changing too much as we move the cursor
    if len(column) < 2
      let l:rhs .= ' '
    endif

    if len(width) < 2
      let l:rhs .= ' '
    endif
  endif
  return rhs
endfunction

function! bti#statusline#diagonstic_info() abort
  let l:coc_info = get(b:, 'coc_diagnostic_info', {})

  let l:coc_msgs = []

  if get(coc_info, 'error', 0)
    call add(coc_msgs, 'E:' . coc_info['error'])
  endif

  if get(coc_info, 'warning', 0)
    call add(coc_msgs, 'W:' . coc_info['warning'])
  endif

  if !empty(coc_msgs)
    return '  ' . join(coc_msgs, ' ') . get(g:, 'coc_status', '') . ' '
  endif

  if !exists('g:loaded_ale')
    return ''
  endif

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = counts.error + counts.style_error
  let l:all_non_errors = counts.total - all_errors

  if counts.total == 0
    return ''
  endif

  if all_errors != 0 && all_non_errors != 0
    return printf('  E:%d W:%d ', all_errors, all_non_errors)
  endif

  return all_errors == 0 ? printf('  W:%d ', all_non_errors) : printf('  E:%d ', all_errors)
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

  if &expandtab && search('\v\t', 'nw') != 0
    call add(status, 'mixed')
  endif

  if len(status)
    let b:statusline_whitespace_check = '  ' . join(status, ' - ') . ' '
  endif

  return b:statusline_whitespace_check
endfunction

function! bti#statusline#whitespace_refresh() abort
  if bufname('%') ==# ''
    return
  endif

  if get(b:, 'statusline_whitespace_changedtick', 0) == b:changedtick
    return
  endif

  unlet! b:statusline_whitespace_changedtick

  let b:statusline_whitespace_changedtick = b:changedtick
endfunction

function! bti#statusline#focus() abort
  if bufname('%') !=# '' && !exists('g:enable_statusline_focus')
    let g:enable_statusline_focus = v:true
  endif

  if exists('g:enable_statusline_focus')
    call s:update_statusline('', 'focus')
  endif
endfunction

function! bti#statusline#blur() abort
  let l:stl = '%<'    " Truncation point
  let l:stl .= '%f'   " Filename
  let l:stl .= '%{bti#statusline#modified()}'   " Modified
  let l:stl .= '%='   " Split left/right halves (makes background cover whole)
  call s:update_statusline(stl, 'blur')
endfunction

function! s:update_statusline(default, action) abort
  let l:statusline = s:get_custom_statusline(a:action)

  if type(statusline) == type('')
    execute 'setlocal statusline=' . statusline
  elseif statusline == 0
    return
  else
    execute 'setlocal statusline=' . a:default
  endif
endfunction

function! s:get_custom_statusline(action) abort
  if &filetype ==# 'help'
    return
          \ '%<'
          \ . '%1*'
          \ . 'Help'
          \ . '\ -\ '
          \ . '%t'
          \ . '%*'
          \ . '%='
  elseif &filetype ==# 'qf'
    return
          \ '%<'
          \ . '%1*'
          \ . 'Quickfix'
          \ . '\ '
          \ . '%*'
          \ . '%2*'
          \ . '%{get(w:,\"quickfix_title\",\"\")}'
          \ . '%*'
          \ . '%='
  elseif &filetype ==# 'Mundo'
    return
          \ '%<'
          \ . '%1*'
          \ . 'Mundo'
          \ . '%*'
          \ . '%='
  elseif &filetype ==# 'MundoDiff'
    return
          \ '%<'
          \ . '%1*'
          \ . 'Mundo\ Preview'
          \ . '%*'
          \ . '%='
  elseif &filetype ==# 'vim-plug'
    return 0
  elseif &filetype ==# 'nerdtree'
    return 0
  endif

  return 1
endfunction
