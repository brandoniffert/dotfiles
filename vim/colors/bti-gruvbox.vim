" Wrap gruvbox and customize

set bg=dark
if $ITERM_PROFILE_BG == 'light'
  set bg=light
endif

let g:colors_name = 'bti-gruvbox'
let g:gruvbox_invert_selection = 0

runtime plugged/gruvbox/colors/gruvbox.vim

hi Normal ctermbg=NONE

let g:vimsyn_noerror = 1

if !exists('g:loaded_airline')
  let g:airline_theme = 'monochrome'
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
endif
