"-------------------------------------------------------------------------------
" vimrc for VS Code
"-------------------------------------------------------------------------------

" Remap leaders
let mapleader = "\<space>"
let maplocalleader = ','

" Navigate over wrapped lines
nnoremap j gj
nnoremap k gk

" Enter command mode
nnoremap <leader><cr> :
vnoremap <leader><cr> :

" Select text that was just pasted
nnoremap <leader>gv V`]

" Easy indent/outdent
nnoremap <tab> >>
nnoremap <s-tab> <<
vnoremap <tab> >gv
vnoremap <s-tab> <gv

" Make Y act like other capital letters
nnoremap Y y$

" Commenting
xmap gc <Plug>VSCodeCommentary
nmap gc <Plug>VSCodeCommentary
omap gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" New splits
nnoremap <silent> <leader>v :Vnew()<cr>
nnoremap <silent> <leader>h :New()<cr>

" Split navigation
nnoremap <silent> <c-h> :<c-u>call VSCodeNotify('workbench.action.focusLeftGroup')<cr>
nnoremap <silent> <c-j> :<c-u>call VSCodeNotify('workbench.action.focusBelowGroup')<cr>
nnoremap <silent> <c-k> :<c-u>call VSCodeNotify('workbench.action.focusAboveGroup')<cr>
nnoremap <silent> <c-l> :<c-u>call VSCodeNotify('workbench.action.focusRightGroup')<cr>
