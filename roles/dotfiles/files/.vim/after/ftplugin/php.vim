setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4

setlocal comments=s1:/**,mb:*,ex:*/,://,:#

" Run current file
setlocal makeprg=php\ -f\ %

" phpactor mappings
nmap <silent> gu :call phpactor#UseAdd()<cr>
nmap <silent> gd :call phpactor#GotoDefinition()<cr>
