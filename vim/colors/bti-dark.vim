let colors_name = "bti-dark"

set bg=dark

let base16colorspace=256
runtime plugged/base16-vim/colors/base16-tomorrow.vim

hi LineNr ctermfg=235 ctermbg=NONE guifg=#444444 guibg=NONE
hi SpellBad guifg=#BF5053 gui=NONE guisp=NONE
hi Search ctermfg=0 guifg=#111111
hi SpecialKey ctermfg=238
hi Comment ctermfg=238

" Airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = 'base16'
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ }
