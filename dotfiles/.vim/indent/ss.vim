setlocal indentexpr=SSIndent()

if exists('*SSIndent')
  finish
endif

let s:start_tags = 'if\|else\|else_if\|loop\|with\|cached'
let s:end_tags = 'else\|else_if\|end_if\|end_loop\|end_with\|end_cached'

function! s:IsStartingDelimiter(lnum) abort
  let l:line = getline(a:lnum)
  return l:line =~# '<%\s\%(' . s:start_tags . '\).*%>'
endfunction

function! s:IsEndingDelimiter(lnum) abort
  let l:line = getline(a:lnum)
  return l:line =~# '<%\s\%(' . s:end_tags . '\).*%>'
endfunction

function! s:IsSingleLineStartEnd(lnum) abort
  return count(getline(a:lnum), '<%') > 1
endfunction

function! SSIndent() abort
  let l:currLine = v:lnum
  let l:prevLine = prevnonblank(l:currLine - 1)
  let l:prevIndent = indent(l:prevLine)

  if l:prevLine == 0
    return 0
  endif

  if s:IsSingleLineStartEnd(l:currLine)
    return l:prevIndent + &shiftwidth
  endif

  if s:IsSingleLineStartEnd(l:prevLine)
    return l:prevIndent - &shiftwidth
  endif

  if s:IsEndingDelimiter(l:currLine)
    return s:IsStartingDelimiter(l:prevLine) ? l:prevIndent : l:prevIndent - &shiftwidth
  endif

  if s:IsStartingDelimiter(l:prevLine)
    return l:prevIndent + &shiftwidth
  endif

  return HtmlIndent()
endfunction
