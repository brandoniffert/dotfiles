let g:airline_symbols_ascii = 1
let g:airline_symbols.branch = ''
let g:airline_symbols.notexists = '?'
let g:airline_theme = 'bti_nord'
let g:airline_skip_empty_sections = 1
let g:airline_highlighting_cache = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#wordcount#enabled = 0

let g:airline_mode_map = {
    \'__' : '-',
    \ 'n'  : 'N',
    \'no' : 'N·Operator Pending',
    \'v'  : 'V',
    \'V'  : 'V·Line',
    \'' : 'V·Block',
    \'s'  : 'Select',
    \'S'  : 'S·Line',
    \'' : 'S·Block',
    \'i'  : 'I',
    \'R'  : 'R',
    \'Rv' : 'V·Replace',
    \'c'  : 'Command',
    \'cv' : 'Vim Ex',
    \'ce' : 'Ex',
    \'r'  : 'Prompt',
    \'rm' : 'More',
    \'r?' : 'Confirm',
    \'!'  : 'Shell',
    \'t'  : 'Terminal'
    \}

function! AirlineInit() abort
  call airline#parts#define('fileprefix', {
    \ 'raw': '%{bti#statusline#FilePrefix()}'
    \ })

  call airline#parts#define('filename', {
    \ 'raw': '%t',
    \ 'accent': 'bold'
    \ })

  call airline#parts#define('filemodified', {
    \ 'raw': ' %m',
    \ 'accent': 'bold'
    \ })

  call airline#parts#define_accent('btireadonly', 'bold')
  call airline#parts#define_function('btireadonly', 'bti#statusline#Readonly')
  call airline#parts#define_function('filetype', 'bti#statusline#FileType')

  let g:airline_section_c = airline#section#create(['btireadonly', 'fileprefix', 'filename', 'filetype', 'filemodified'])

  call airline#parts#define('linescols', {
    \ 'raw' : '%3p%% %2l/%2L:%3c',
    \ 'accent' : 'bold'
    \ })

  let g:airline_section_z = airline#section#create(['linescols'])
  let g:airline_section_x = airline#section#create(['gutentags'])

  let l:airline_section_a = substitute(get(g:, 'airline_section_a', ''), '%#__restore__#', '', '') . '%#__restore__#'
  let g:airline_section_a = l:airline_section_a
endfunction

autocmd User AirlineAfterInit call AirlineInit()
