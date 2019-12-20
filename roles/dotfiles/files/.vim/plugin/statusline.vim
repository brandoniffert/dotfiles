set laststatus=2

set statusline=
set statusline+=%<                                  " Truncation point
set statusline+=%{bti#statusline#file_prefix()}     " Relative path excluding filename
set statusline+=%1*                                 " Bold
set statusline+=%t                                  " Filename
set statusline+=%{bti#statusline#modified()}        " Modified/readonly
set statusline+=%*                                  " Reset highlight group
set statusline+=\                                   " Space
set statusline+=%((%2*%{bti#statusline#ft()}%*)%)   " File type in italics
set statusline+=%=                                  " Split point for left and right groups
set statusline+=%{bti#statusline#rhs()}             " File encoding and line/column info
set statusline+=%1*                                 " Bold
set statusline+=%{bti#statusline#whitespace()}      " Whitespace indicator
set statusline+=%{bti#statusline#diagonstic_info()} " Diagnostic info
set statusline+=%*                                  " Reset highlight group

augroup btiStatusline
  autocmd!
  autocmd CursorHold,BufWritePost * call bti#statusline#whitespace_refresh()

  autocmd BufEnter,FocusGained,WinEnter * call bti#statusline#focus()
  autocmd FocusLost,WinLeave * call bti#statusline#blur()

  " Delay enabling focus so the screen isn't immediately cleared on startup
  autocmd CursorHold * call bti#statusline#enable_focus()
augroup END
