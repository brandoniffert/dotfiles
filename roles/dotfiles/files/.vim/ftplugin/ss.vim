let s:cpo_save = &cpoptions
set cpoptions&vim

if exists('loaded_matchit') && exists('b:match_words')
  let b:match_words = '\<\if.*%>:\<else.*%>:\<else_if.*%>:\<end_if.*%>'
        \ . ',\<\with.*%>:\<end_with.*%>'
        \ . ',\<control\>:\<end_control\>'
        \ . ',\<\loop.*%>:\<end_loop.*%>'
        \ . ',\<cached\>:\<end_cached\>'
        \ . ',' . b:match_words
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save
