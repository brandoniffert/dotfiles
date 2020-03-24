let g:ale_cache_executable_check_failures = 1
let g:ale_close_preview_on_insert = 1
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_lint_delay = 100
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:ale_virtualtext_cursor = 1

let g:ale_linters = {
      \ 'sh': ['shellcheck'],
      \ 'php': ['phpcs', 'php'],
      \ 'yaml': ['yamllint'],
      \ 'vim': ['vint']
      \ }

let g:ale_fixers = {
      \ 'php': ['php_cs_fixer']
      \ }

let g:ale_php_phpcs_executable = './vendor/bin/phpcs'
let g:ale_php_php_cs_fixer_executable = './vendor/bin/php-cs-fixer'

nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
nmap <silent> <leader>gf <Plug>(ale_fix)
