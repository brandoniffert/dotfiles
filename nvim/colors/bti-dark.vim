set bg=dark
runtime plugged/Spacegray.vim/colors/spacegray.vim

let colors_name = "bti-dark"

hi LineNr ctermfg=236 guifg=#303030

" Airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = 'monochrome'
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
