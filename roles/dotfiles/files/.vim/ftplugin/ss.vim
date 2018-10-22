let s:cpo_save = &cpo
set cpo&vim

if exists('loaded_matchit') && exists('b:match_words')
  let b:match_words = '\<\if.*%>:\<else.*%>:\<else_if.*%>:\<end_if.*%>'
        \ . ',\<\with.*%>:\<end_with.*%>'
        \ . ',\<control\>:\<end_control\>'
        \ . ',\<\loop.*%>:\<end_loop.*%>'
        \ . ',' . b:match_words
endif

let &cpo = s:cpo_save
unlet s:cpo_save
