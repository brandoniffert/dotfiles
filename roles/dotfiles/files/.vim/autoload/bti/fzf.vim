" Call rg and filter with FZF but allow passing through flags (ex: --no-hidden -tjs)
function! bti#fzf#rg_with_opts(arg, bang) abort
  let rg_cmd = 'rg --line-number --smart-case --hidden --color=always --colors=path:none --colors=line:none --colors=match:fg:red '
  let tokens = split(a:arg)
  let rg_opts = join(filter(copy(tokens), 'v:val =~# "^-"'))
  let query = join(filter(copy(tokens), 'v:val !~# "^-"'))
  let cmd = rg_cmd . rg_opts . ' ' . shellescape(query)
  let preview_type = a:bang ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?')

  return call('fzf#vim#grep', [cmd, 0, preview_type])
endfunction
