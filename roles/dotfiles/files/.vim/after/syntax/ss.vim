syn match ssBlock /<%\s*.*\s*%>/ containedin=htmlTag
syn region ssComment start=+<%--+ end=+--%>+ contains=@Spell
syn match ssOperator /\v\|\||\&\&|\=\=\=|\=\=/ contained containedin=ssBlock
syn match ssKeyword /\vend_if|if|else_if|else/ contained containedin=ssBlock
syn match ssKeyword /\vcontrol|end_control|loop|end_loop|with|end_with|include/ contained containedin=ssBlock
syn match ssString /\v"[^"]*"/ contained containedin=ssBlock
syn match ssString /\v'[^']*'/ contained containedin=ssBlock

hi def link ssBlock Function
hi def link ssOperator Operator
hi def link ssKeyword Keyword
hi def link ssComment Comment
hi def link ssString String
