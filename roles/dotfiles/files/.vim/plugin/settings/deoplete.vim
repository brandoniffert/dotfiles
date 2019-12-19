if has('nvim')
  let g:deoplete#enable_at_startup = 0

  augroup btiDeoplete
    autocmd InsertEnter * call deoplete#enable()
  augroup END

  inoremap <silent><expr><tab>
        \ pumvisible() ? "\<c-n>" :
        \ <SID>check_back_space() ? "\<tab>" :
        \ deoplete#manual_complete()

  inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
