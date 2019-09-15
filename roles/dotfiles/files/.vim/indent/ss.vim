setlocal indentexpr=SSIndent()

if exists('*SSIndent')
  finish
endif

let s:start_tags = 'if\|else\|else_if\|loop\|with\|cached'
let s:end_tags = 'else\|else_if\|end_if\|end_loop\|end_with\|end_cached'

function! s:IsStartingTag(lnum) abort
  let line = getline(a:lnum)
  return line =~# '<%\s\%(' . s:start_tags . '\)\s\+\w*\s\+%>'
endfunction

function! SSIndent() abort
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  let line = getline(lnum)
  let cline = getline(v:lnum)
  let indent = indent(lnum)

  if cline =~# '<%\s\%(' . s:end_tags . '\)\s\+%>'
    return s:IsStartingTag(lnum) ? indent : indent - &sw
  endif

  if s:IsStartingTag(lnum)
    return indent + &sw
  endif

  return HtmlIndent()
endfunction
