" FZF Rg variant that uses a custom rg cmd and preview script
function! bti#fzf#rg_with_opts(args, bang) abort
  let s:input = s:smart_quote_input(a:args)
  let s:base_rg_cmd = 'rg --line-number --hidden --smart-case -g !.git '
  let s:rg_cmd = a:bang ? s:base_rg_cmd . '--no-ignore ' : s:base_rg_cmd . '--ignore '
  let s:cmd = s:rg_cmd . s:input

  return call('fzf#vim#grep', [s:cmd, 0, fzf#vim#with_preview()])
endfunction

function! s:smart_quote_input(input)
  let hasQuotes = match(a:input, '"') > -1 || match(a:input, "'") > -1
  let hasOptions = match(' ' . a:input, '\s-[-a-zA-Z]') > -1
  let hasEscapedSpacesPlusPath = match(a:input, '\\ .*\ ') > 0
  return hasQuotes || hasOptions || hasEscapedSpacesPlusPath ? a:input : '-- "' . a:input . '"'
endfunction

function! bti#fzf#rg_files(args, bang) abort
  let s:base_rg_cmd = 'rg --files --smart-case --hidden --follow --glob "!.git/*"'
  let opts = {'source': s:base_rg_cmd, 'options': '-m'}
  let file_opts = opts

  if a:bang && &columns >= 80 || &columns >= 120
    let file_opts = fzf#vim#with_preview(opts)
  endif

  return call('fzf#vim#files', [a:args, file_opts, a:bang])
endfunction
