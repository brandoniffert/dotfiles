" Using the old regexp engine in 7.4 speeds up ruby syntax highlighting
" http://stackoverflow.com/a/16920294
if v:version > 703
  setlocal regexpengine=1
endif

" Run current file
setlocal makeprg=ruby\ %
