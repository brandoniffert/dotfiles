let g:lightline = {}

let g:lightline.colorscheme = 'bti_nord'

let g:lightline.mode_map = {
      \  'n' : 'N',
      \  'no': 'N·Operator Pending',
      \  'i' : 'I',
      \  'R' : 'R',
      \  'v' : 'V',
      \  'V' : 'V·Line',
      \  '\<C-v>': 'V·Block',
      \  'c' : 'Command',
      \  's' : 'Select',
      \  'S' : 'S·Line',
      \  '\<C-s>': 'S·Block',
      \  't': 'Terminal',
      \ }

let g:lightline.subseparator = { 'left': '·', 'right': '·' }

let g:lightline.active = {
      \  'left': [
      \    [ 'mode', 'paste', 'spell' ],
      \    [ 'readonly', 'filename'],
      \    [ 'filetype' ],
      \    [ 'modified' ]
      \  ],
      \  'right': [
      \    [ 'whitespace' ],
      \    [ 'linterinfo' ],
      \    [ 'percent', 'lineinfo' ],
      \    [ 'fileformatencoding' ],
      \    [ 'selectedlines' ]
      \  ]
      \ }

let g:lightline.inactive = {
      \  'left': [ [ 'fullfilename', 'modified' ] ],
      \  'right': []
      \ }

let g:lightline.component = {
      \  'mode': '%{bti#statusline#Mode()}',
      \  'fullfilename': '%f',
      \  'filename': '%{bti#statusline#FilePrefix()}%1*%t%2*',
      \  'modified': '%{bti#statusline#Modified()}',
      \  'readonly': '%{bti#statusline#Readonly()}',
      \  'fileformatencoding': '%{bti#statusline#FileFormatEncoding()}',
      \  'filetype': '%{bti#statusline#FileType()}',
      \  'spell': '%{&spell? "SPELL" : ""}',
      \  'selectedlines': '%{bti#statusline#SelectedLines()}',
      \  'close': '',
      \ }

let g:lightline.component_type = {
      \  'linterinfo': 'warning',
      \  'whitespace': 'warning',
      \ }

let g:lightline.component_expand = {
      \  'linterinfo': 'bti#statusline#LinterInfo',
      \  'whitespace': 'bti#statusline#Whitespace',
      \ }

let g:lightline.component_visible_condition = {
      \  'readonly': 'bti#statusline#Readonly() !=# ""',
      \  'filetype': 'bti#statusline#FileType() !=# ""',
      \  'modified': 'bti#statusline#Modified() !=# ""',
      \  'fileformatencoding': 'bti#statusline#FileFormatEncoding() !=# ""',
      \  'selectedlines': 'bti#statusline#SelectedLines() !=# ""',
      \  'percent': 0
      \ }

augroup LightlineStatusline
  autocmd!
  autocmd User ALEJobStarted call lightline#update()
  autocmd User ALELintPost call lightline#update()
  autocmd User ALEFixPost call lightline#update()
  autocmd CursorHold,BufWritePost * call bti#statusline#WhitespaceRefresh()
augroup END
