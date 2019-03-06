if exists('b:current_syntax')
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'html'
endif

runtime! syntax/html.vim
unlet b:current_syntax

syn match ssBlock /<%\s*.*\s*%>/ contains=htmlTag
syn region ssComment start=+<%--+ end=+--%>+ contains=@Spell
syn match ssOperator /\v\|\||\&\&|\=\=\=|\=\=/ contained
syn match ssKeyword /\vend_if|if|else_if|else/ contained
syn match ssKeyword /\vcontrol|end_control|loop|end_loop|with|end_with|include/ contained
syn match ssString /\v"[^"]*"/ contained
syn match ssString /\v'[^']*'/ contained

hi def link ssBlock Function
hi def link ssOperator Operator
hi def link ssKeyword Keyword
hi def link ssComment Comment
hi def link ssString String

let b:current_syntax = 'ss'
let main_syntax = 'html'
