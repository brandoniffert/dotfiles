" FZF Rg variant that uses a custom rg cmd and preview script
function! bti#fzf#rg_with_opts(args, bang) abort
  let s:base_rg_cmd = 'rg --line-number --hidden --smart-case '
  let s:rg_cmd = a:bang ? s:base_rg_cmd . '--no-ignore ' : s:base_rg_cmd . '--ignore '
  let s:cmd = s:rg_cmd . a:args

  let s:preview_script = $HOME . '/.vim/bin/fzf-vim-preview.sh'
  let s:preview_opts = {
        \  'options': [
        \    '--preview-window',
        \    'right:50%',
        \    '--preview', '' . s:preview_script . ' {}',
        \    '--bind',
        \    '?:toggle-preview'
        \  ]
        \ }

  return call('fzf#vim#grep', [s:cmd, 0, s:preview_opts])
endfunction
