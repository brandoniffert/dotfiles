set bg=dark
let base16colorspace=256

runtime plugged/base16-vim/colors/base16-tomorrow.vim

hi LineNr ctermfg=238 ctermbg=NONE guifg=#444444 guibg=NONE
hi SpellBad ctermfg=red guifg=#BF5053 gui=NONE guisp=NONE
hi Search ctermfg=black guifg=#111111
hi SpecialKey ctermfg=238

" Airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = 'monochrome'
