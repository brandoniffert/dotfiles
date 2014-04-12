" use base16-tomorrow - allow for some overrides

let base16colorspace=256
runtime bundle/base16-vim/colors/base16-tomorrow.vim

let g:colors_name = "bti-base16"

hi Normal ctermbg=NONE
hi VertSplit term=reverse cterm=NONE ctermbg=NONE ctermfg=59 gui=NONE guibg=NONE guifg=#5f5f5f
hi TabLineFill ctermbg=252
hi TabLineSel ctermbg=NONE ctermfg=254
hi SpellBad ctermfg=red ctermbg=NONE cterm=underline
hi StatusLineNC ctermfg=244 ctermbg=234
hi LineNr ctermbg=NONE ctermfg=236
