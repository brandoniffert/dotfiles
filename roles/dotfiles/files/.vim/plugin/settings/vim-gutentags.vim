let g:gutentags_cache_dir = '~/.vim/tmp/tags'

if exists('$SUDO_USER')
  let g:gutentags_dont_load = 1
endif

if executable('rg')
  let g:gutentags_file_list_command = 'rg --files'
endif
