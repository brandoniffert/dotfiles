let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:airline#extensions#ale#enabled = 1

let g:ale_linters = {
\   'html': [],
\   'graphql': []
\}

let g:ale_fixers = {
\   'php': ['php_cs_fixer'],
\}

let g:ale_php_cs_fixer_options = "--rules='{\"@Symfony\": true, \"no_alternative_syntax\": true, \"array_syntax\": { \"syntax\": \"short\" }, \"concat_space\": { \"spacing\": \"one\" }}'"

nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
nmap <silent> <leader>gf <Plug>(ale_fix)
