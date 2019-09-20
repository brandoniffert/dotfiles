command! ReplaceFancyCharacters call bti#functions#ReplaceFancyCharacters()
command! StripWhitespace call bti#functions#StripWhitespace()
command! -bang -nargs=+ -complete=dir Rg call bti#fzf#rg_with_opts(<q-args>, <bang>0)
command! -nargs=* -complete=file Preview call bti#functions#Preview(<f-args>)
