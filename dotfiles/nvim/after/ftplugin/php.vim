setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4

setlocal comments=s1:/**,mb:*,ex:*/,://,:#

" Run current file
setlocal makeprg=php\ -f\ %

" phpactor mappings
nmap <silent> gu :call phpactor#UseAdd()<cr>
nmap <silent> gd :call phpactor#GotoDefinition()<cr>

" Turn off syntax highlighting for html and SQL
let php_html_load=0
let php_html_in_heredoc=0
let php_html_in_nowdoc=0

let php_sql_query=0
let php_sql_heredoc=0
let php_sql_nowdoc=0
