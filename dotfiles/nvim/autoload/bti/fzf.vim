" FZF Rg variant that uses a custom rg cmd and preview script
function! bti#fzf#rg_with_opts(args, bang) abort
  let l:input = s:smart_quote_input(a:args)
  let l:base_rg_cmd = 'rg --line-number --hidden --smart-case -g !.git '
  let l:rg_cmd = a:bang ? l:base_rg_cmd . '--no-ignore ' : l:base_rg_cmd . '--ignore '
  let l:cmd = rg_cmd . input

  return call('fzf#vim#grep', [cmd, 0, fzf#vim#with_preview()])
endfunction

function! s:smart_quote_input(input)
  let l:hasQuotes = match(a:input, '"') > -1 || match(a:input, "'") > -1
  let l:hasOptions = match(' ' . a:input, '\s-[-a-zA-Z]') > -1
  let l:hasEscapedSpacesPlusPath = match(a:input, '\\ .*\ ') > 0
  return l:hasQuotes || l:hasOptions || l:hasEscapedSpacesPlusPath ? a:input : '-- "' . a:input . '"'
endfunction

function! bti#fzf#all_files(args, bang) abort
  let l:base_fzf_cmd = $FZF_DEFAULT_COMMAND . ' --no-ignore'
  let l:opts = {'source': l:base_fzf_cmd, 'options': '-m'}
  let l:file_opts = l:opts

  if a:bang && &columns >= 80 || &columns >= 120
    let l:file_opts = fzf#vim#with_preview(l:opts)
  endif

  return call('fzf#vim#files', [a:args, l:file_opts, a:bang])
endfunction
