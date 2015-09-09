" Wrap gruvbox and customize

set bg=dark
if $ITERM_PROFILE_BG == 'light'
  set bg=light
endif

let g:colors_name = 'bti-gruvbox'
let g:gruvbox_invert_selection = 0

runtime plugged/gruvbox/colors/gruvbox.vim

let g:vimsyn_noerror = 1
let g:airline_powerline_fonts = 1
