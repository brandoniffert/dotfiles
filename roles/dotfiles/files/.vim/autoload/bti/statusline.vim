function! s:IgnoreBuffer(name) abort
  let ignore = 'NERD*\|help\|nofile\|__Mundo*'

  return match(a:name, ignore) > -1
endfunction

function! bti#statusline#Mode() abort
  return &filetype ==# 'nerdtree' ? 'NERD' :
        \ &filetype ==# 'help' ? 'HELP' :
        \ &filetype ==# 'vim-plug' ? 'PLUGINS' :
        \ &filetype ==# 'Mundo' ? 'MUNDO' :
        \ &filetype ==# 'MundoDiff' ? 'MUNDO' :
        \ get(g:lightline.mode_map, mode(1), '')
endfunction

function! bti#statusline#Readonly() abort
  if !empty(&buftype) || <sid>IgnoreBuffer(&buftype)
    return ''
  endif

  if &readonly && !filereadable(bufname('%'))
    return 'NOPERM'
  else
    return &readonly ? 'READONLY' : ''
  endif
endfunction

function! bti#statusline#FilePrefix() abort
  let basename = expand('%:h')

  if basename ==# '' || basename ==# '.'
    return ''
  else
    return substitute(basename . '/', '\C^' . $HOME, '~', '')
  endif
endfunction

function! bti#statusline#FileType() abort
  if !empty(&buftype) || <sid>IgnoreBuffer(&buftype)
    return ''
  endif

  return strlen(&filetype) ? &filetype : ''
endfunction

function! bti#statusline#Modified() abort
  if !empty(&buftype) || <sid>IgnoreBuffer(&buftype)
    return ''
  endif

  return &modified && &modifiable ? '(modified)' : ''
endfunction

function! bti#statusline#FileFormatEncoding() abort
  if !empty(&buftype) || <sid>IgnoreBuffer(&buftype) || empty(bufname('%'))
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
    return &fileencoding . bomb . ff
  endif
endfunction

function! bti#statusline#LinterInfo() abort
  let counts = ale#statusline#Count(bufnr(''))
  let all_errors = counts.error + counts.style_error
  let all_non_errors = counts.total - all_errors

  if counts.total == 0
    return ''
  endif

  if all_errors != 0 && all_non_errors != 0
    return printf('E: %d W: %d', all_errors, all_non_errors)
  endif

  return all_errors == 0 ? printf('W: %d', all_non_errors) : printf('E: %d', all_errors)
endfunction

function! bti#statusline#Whitespace() abort
  if !exists('b:statusline_whitespace_check')

    if !&modifiable
      let b:statusline_whitespace_check = ''
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
      let b:statusline_whitespace_check = join(status, ' · ')
    endif
  endif

  return b:statusline_whitespace_check
endfunction

function! bti#statusline#SelectedLines() abort
  let lines = abs(line('.') - line('v')) + 1

  if lines <= 1
    return ''
  endif

  return lines
endfunction

function! bti#statusline#WhitespaceRefresh() abort
  unlet! b:statusline_whitespace_check
endfunction
