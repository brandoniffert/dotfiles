" Wrap Tomorrow-Night theme and customize
" Also sets Airline theme if available

runtime colors/Tomorrow-Night.vim

let g:colors_name = 'bti-tomorrow-dark'
let g:vimsyn_noerror = 1
let g:airline#themes#base16#constant = 1
let g:airline_theme = 'base16'

highlight link pythonImport pythonFunction

hi Normal       ctermbg=NONE
hi CursorLineNr              ctermfg=4   cterm=NONE                 guifg=#6F90B0 gui=NONE
hi Search       ctermbg=NONE ctermfg=3   cterm=underline
hi SpellBad     ctermbg=NONE ctermfg=1   cterm=underline
hi LineNr       ctermbg=NONE ctermfg=237                 guibg=NONE guifg=#3a3a3a
hi Visual       ctermbg=237
