" Cleaner/simpler clone of the built-in tabline, but without the window
" counts, the modified flag, or the close widget.
" See: https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/autoload/wincent/tabline.vim

function bti#tabline#line() abort
  let l:line=''
  let l:current=tabpagenr()
  for i in range(1, tabpagenr('$'))
    if i == current
      let l:line.='%#TabLineSel#'
    else
      let l:line.='%#TabLine#'
    end
    let l:line.='%' . i . 'T' " Starts mouse click target region.
    let l:line.=' %{bti#tabline#label(' . i . ')} '
  endfor
  let l:line.='%#TabLineFill#'
  let l:line.='%T' " Ends mouse click target region(s).
  return line
endfunction

function bti#tabline#label(n) abort
  let l:buflist = tabpagebuflist(a:n)
  let l:winnr = tabpagewinnr(a:n)
  return pathshorten(fnamemodify(bufname(buflist[winnr - 1]), ':~:.'))
endfunction
