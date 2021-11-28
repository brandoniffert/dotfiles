scriptencoding utf-8

function! bti#statusline#modified() abort
  return &modified && &modifiable ? ' ✕' : ''
endfunction

function! bti#statusline#readonly() abort
  return !&modifiable || &readonly ? ' [RO]' : ''
endfunction

function! bti#statusline#filename_prefix() abort
  let l:basename=expand('%:h')

  if l:basename ==# '' || l:basename ==# '.'
    return ''
  elseif has('modify_fname')
    " Make sure we show $HOME as ~
    return substitute(fnamemodify(l:basename, ':~:.'), '/$', '', '') . '/'
  else
    " Make sure we show $HOME as ~
    return substitute(l:basename . '/', '\C^' . $HOME, '~', '')
  endif
endfunction

function! bti#statusline#filename() abort
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
    return ''
  elseif &filetype ==# 'nerdtree'
    return ''
  endif

  return '%t'
endfunction

function! bti#statusline#ffenc() abort
  if !empty(&buftype) || empty(bufname('%'))
    return ''
  endif

  let l:expected_ff = 'unix'
  let l:expected_fenc = 'utf-8'
  let l:expected = l:expected_fenc . ' [' . l:expected_ff. ']'
  let l:expected_empty_fenc = '[' . l:expected_ff. ']'
  let l:bomb = &bomb ? '[BOM]' : ''
  let l:ff = strlen(&fileformat) ? ' [' . &fileformat . ']' : ''

  if l:expected is# &fileencoding . l:bomb . l:ff
    return ''
  else if l:expected_empty_fenc is# l:bomb . l:ff
    return ''
  else
    return &fileencoding . l:bomb . l:ff . ' '
  endif
endfunction

function! bti#statusline#whitespace() abort
  let b:statusline_whitespace_check = ''

  if !&modifiable
    return b:statusline_whitespace_check
  endif

  let l:status = []

  if search('\s$', 'nw') != 0
    call add(l:status, 'trailing')
  endif

  if &expandtab && search('\v\t', 'nw') != 0
    call add(l:status, 'mixed')
  endif

  if len(l:status)
    let b:statusline_whitespace_check = join(l:status, ' - ')
  endif

  return b:statusline_whitespace_check
endfunction
