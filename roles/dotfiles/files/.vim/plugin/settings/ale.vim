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

let g:ale_php_phpcs_executable = './vendor/bin/phpcs'
let g:ale_php_php_cs_fixer_executable = './vendor/bin/php-cs-fixer'
let g:ale_virtualtext_cursor = 1

nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
nmap <silent> <leader>gf <Plug>(ale_fix)
