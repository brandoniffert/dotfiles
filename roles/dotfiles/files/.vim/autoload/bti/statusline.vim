" Gets file prefix
function! bti#statusline#FilePrefix() abort
  let l:basename = expand('%:h')
  if l:basename ==# '' || l:basename ==# '.'
    return ''
  else
    " Make sure we show $HOME as ~
    return substitute(l:basename . '/', '\C^' . $HOME, '~', '')
  endif
endfunction

" Gets filetype
function! bti#statusline#FileType() abort
  if strlen(&ft)
    return ' (' . &ft . ')'
  else
    return ''
  endif
endfunction

" Gets readonly
function! bti#statusline#Readonly() abort
  " Only consider regular buffers (e.g. ones that represent actual files,
  " but not special ones like e.g. NERDTree)
  if !empty(&buftype) || airline#util#ignore_buf(bufname('%'))
    return ''
  endif
  if &readonly && !filereadable(bufname('%'))
    return 'NOPERM '
  else
    return &readonly ? 'READONLY ' : ''
  endif
endfunction
