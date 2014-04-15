" use base16-tomorrow - allow for some overrides

let base16colorspace=256
runtime bundle/base16-vim/colors/base16-tomorrow.vim

let g:colors_name = "bti-base16-override"

hi Normal ctermbg=NONE
hi SpellBad ctermfg=red ctermbg=NONE cterm=underline
hi StatusLineNC ctermbg=234 ctermfg=244
hi LineNr ctermbg=NONE ctermfg=236
hi StatusLine ctermbg=20 ctermfg=18
