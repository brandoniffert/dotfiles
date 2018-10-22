scriptencoding utf-8

let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {
\   'html': [],
\}

nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
