setlocal indentexpr=SSIndent()

if exists('*SSIndent')
  finish
endif

let s:start_tags = 'if\|else\|else_if\|loop\|with\|cached'
let s:end_tags = 'else\|else_if\|end_if\|end_loop\|end_with\|end_cached'

function! s:IsStartingTag(lnum) abort
  let l:line = getline(a:lnum)
  return l:line =~# '<%\s\%(' . s:start_tags . '\)\s\+\w*\s\+%>'
endfunction

function! SSIndent() abort
  let l:lnum = prevnonblank(v:lnum - 1)
  if l:lnum == 0
    return 0
  endif

  let l:line = getline(l:lnum)
  let l:cline = getline(v:lnum)
  let l:indent = indent(l:lnum)

  if l:cline =~# '<%\s\%(' . s:end_tags . '\)\s\+%>'
    return s:IsStartingTag(l:lnum) ? l:indent : l:indent - &shiftwidth
  endif

  if s:IsStartingTag(l:lnum)
    return l:indent + &shiftwidth
  endif

  return HtmlIndent()
endfunction
