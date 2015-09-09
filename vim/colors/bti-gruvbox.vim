" Wrap gruvbox and customize

set bg=dark
if $ITERM_PROFILE_BG == 'light'
  set bg=light
endif

let g:colors_name = 'bti-gruvbox'
let g:gruvbox_invert_selection = 0
let g:gruvbox_contrast_dark = 'soft'

runtime plugged/gruvbox/colors/gruvbox.vim

let g:vimsyn_noerror = 1
