" use spacegray - allow for some overrides

set bg=dark
runtime plugged/Spacegray.vim/colors/spacegray.vim
let g:colors_name = "bti-dark"

hi Normal            ctermbg=NONE
hi LineNr            ctermbg=NONE ctermfg=235
hi CursorLine        ctermbg=234
hi CursorLineNr      ctermbg=234

hi Pmenu             ctermbg=238  ctermfg=250  cterm=NONE
hi PmenuSbar         ctermbg=240  ctermfg=NONE cterm=NONE
hi PmenuSel          ctermbg=159  ctermfg=235  cterm=NONE
hi PmenuThumb        ctermbg=66   ctermfg=66   cterm=NONE

hi SneakStreakTarget ctermbg=red  ctermfg=white
hi SneakStreakMask   ctermbg=NONE ctermfg=white
