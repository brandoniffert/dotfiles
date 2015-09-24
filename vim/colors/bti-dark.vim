let colors_name = "bti-dark"

set bg=dark

runtime plugged/Apprentice/colors/apprentice.vim

hi LineNr ctermfg=235 ctermbg=NONE guifg=#444444 guibg=NONE
hi SpellBad guifg=#BF5053 gui=NONE guisp=NONE
hi Normal ctermbg=NONE guibg=#101010
hi SpecialKey ctermfg=235

" Airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = 'bubblegum'
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
