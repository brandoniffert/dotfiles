let g:NERDTreeCreatePrefix = 'silent keepalt keepjumps'
let g:NERDTreeMouseMode = 2
let g:NERDTreeHighlightCursorline = 0
let g:NERDTreeMinimalUI = 1
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 40

augroup NERDTreeSettings
  autocmd!
  autocmd User NERDTreeInit call bti#functions#AttemptSelectLastFile()
augroup END
