set vb t_vb=

set guioptions=
set guifont=Source\ Code\ Pro:h13

let [g:ctrlp_max_height, g:ctrlp_working_path_mode] = [20, 0]
let [g:ctrlp_show_hidden, g:ctrlp_use_caching] = [0, 0]
let g:ctrlp_map = '<leader>f'

nnoremap <silent><leader>b :CtrlPBuffer<cr>
nnoremap <silent><leader>f :CtrlP<cr>

" Have ctrlp use ag if available - much faster
if executable("ag")
  let g:ctrlp_user_command = 'ag %s -l -S --hidden -g ""'
endif
