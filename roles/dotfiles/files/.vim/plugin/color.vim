augroup NordOverrides
  autocmd!
  autocmd ColorScheme nord highlight! CursorLine guibg=#2B303B
  autocmd ColorScheme nord highlight! Error cterm=bold guifg=#D8DEE9 gui=bold
  autocmd ColorScheme nord highlight! ErrorMsg cterm=bold gui=bold
  autocmd ColorScheme nord highlight! Folded guifg=#7b88a1 guibg=#2E3440 gui=NONE
  autocmd ColorScheme nord highlight! IncSearch cterm=bold guibg=#ebcb8b gui=bold
  autocmd ColorScheme nord highlight! LineNr guibg=NONE guifg=#363d4a
  autocmd ColorScheme nord highlight! Normal guibg=NONE
  autocmd ColorScheme nord highlight! Pmenu guibg=#2E3440 ctermbg=16
  autocmd ColorScheme nord highlight! PmenuSel guibg=#e5e9f0 guifg=#2E3440 gui=bold ctermbg=7 ctermfg=16 cterm=bold
  autocmd ColorScheme nord highlight! QuickScopePrimary guifg=#bf616a gui=underline,bold ctermfg=1 cterm=underline,bold
  autocmd ColorScheme nord highlight! QuickScopeSecondary guifg=#bf616a gui=bold ctermfg=1 cterm=bold
  autocmd ColorScheme nord highlight! Search guifg=#bf616a ctermfg=1 guibg=NONE ctermbg=NONE cterm=underline,bold gui=underline,bold
  autocmd ColorScheme nord highlight! SignColumn guibg=NONE
  autocmd ColorScheme nord highlight! Statement gui=NONE
  autocmd ColorScheme nord highlight! StatusLine guibg=#171a26 guifg=#E5E9F0 ctermbg=16 ctermfg=7
  autocmd ColorScheme nord highlight! StatusLineNC guibg=#171a26
  autocmd ColorScheme nord highlight! TabLine guibg=#15171E guifg=#D8DEE9
  autocmd ColorScheme nord highlight! TabLineFill guifg=#D8DEE9 guibg=NONE
  autocmd ColorScheme nord highlight! TabLineSel guibg=#D8DEE9 guifg=#12141e
  autocmd ColorScheme nord highlight! VertSplit guibg=NONE guifg=#2E3440
  autocmd ColorScheme nord highlight! Visual guibg=#2E3440
  autocmd ColorScheme nord highlight! WarningMsg cterm=bold gui=bold
  autocmd ColorScheme nord highlight! link CursorLineNr LineNr
  autocmd ColorScheme nord highlight! link NERDTreeCWD Comment
  autocmd ColorScheme nord highlight! link Sneak WarningMsg
  autocmd ColorScheme nord highlight! link jsObjectKey jsonKeyword
  autocmd ColorScheme nord highlight! link Wildmenu PmenuSel
  autocmd ColorScheme nord highlight! def Dim cterm=NONE ctermbg=NONE ctermfg=0 guifg=#576279
augroup END

let g:nord_underline = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1

" Set vim-specific sequences for RGB colors
if !has('nvim')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

silent! colorscheme nord
