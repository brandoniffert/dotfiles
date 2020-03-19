" Set env var here so it only applies to vim sessions
let $FZF_PREVIEW_COMMAND="cat {}"

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

command! RgFiles call fzf#run(fzf#wrap({'source': 'rg --files --smart-case --hidden --follow --glob "!.git/*"'}))

nnoremap <silent> <leader>f :RgFiles<cr>
nnoremap <silent> <leader>F :Files<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>H :Helptags<cr>

nnoremap <leader>a :Rg<space>
