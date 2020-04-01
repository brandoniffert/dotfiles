let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-tsserver',
      \ 'coc-json',
      \ 'coc-vimlsp',
      \ 'coc-yank'
      \ ]

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <tab>
      \ pumvisible() ? "\<c-n>" :
      \ <sid>check_back_space() ? "\<tab>" :
      \ coc#refresh()
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<c-h>"

function! s:check_back_space() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<c-y>" : "\<c-g>u\<cr>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Goto code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <sid>show_documentation()<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList
"
" Show all diagnostics
nnoremap <silent> <leader>ca :<c-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>ce :<c-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>cc :<c-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>co :<c-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>cs :<c-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent> <leader>cj :<c-u>CocNext<cr>
" Do default action for previous item
nnoremap <silent> <leader>ck :<c-u>CocPrev<cr>
" Resume latest coc list
nnoremap <silent> <leader>cp :<c-u>CocListResume<cr>
" Show yank list
nnoremap <silent> <leader>cy :<c-u>CocList -A --normal yank<cr>
