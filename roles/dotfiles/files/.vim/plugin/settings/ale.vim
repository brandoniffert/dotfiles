let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {
\   'html': [],
\   'graphql': []
\}

nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
