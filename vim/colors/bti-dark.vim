" use spacegray - allow for some overrides

set bg=dark
runtime plugged/xoria256.vim/colors/xoria256.vim
let g:colors_name = "bti-dark"

hi NonText           ctermbg=NONE
hi Normal            ctermbg=NONE
hi LineNr            ctermbg=NONE ctermfg=235
hi CursorLine        ctermbg=234
hi CursorLineNr      ctermbg=234

hi SneakStreakTarget ctermbg=red  ctermfg=255
hi SneakStreakMask   ctermbg=NONE ctermfg=255
