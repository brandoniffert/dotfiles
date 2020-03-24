" Set env var here so it only applies to vim sessions
let $FZF_PREVIEW_COMMAND="cat {}"

if has('nvim')
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'border': 'sharp' } }
endif

command! -bang -nargs=? -complete=dir RgFiles call bti#fzf#rg_files(<q-args>, <bang>0)
command! -bang -nargs=+ -complete=dir Rg call bti#fzf#rg_with_opts(<q-args>, <bang>0)

nnoremap <leader>a :Rg<space>
nnoremap <silent> <leader>f :RgFiles<cr>
nnoremap <silent> <leader>F :Files<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>H :Helptags<cr>

function! s:fzf_statusline() abort
  setlocal statusline=%1*fzf
endfunction

augroup btiFzf
  autocmd!
  autocmd! User FzfStatusLine call <sid>fzf_statusline()
augroup END
