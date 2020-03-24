if bufname('%') != ''
  setlocal spell
endif

setlocal formatoptions-=t
setlocal conceallevel=0

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = [
      \ 'html',
      \ 'css',
      \ 'scss',
      \ 'sql',
      \ 'js=javascript',
      \ 'javascript',
      \ 'python',
      \ 'bash=sh',
      \ 'php',
      \ 'ruby',
      \ 'vim',
      \ 'help'
      \ ]
