let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:nord000 = ['#11141d', 16]
let s:nord00 = ['#131620', 16]
let s:nord0 = ['#2E3440', 16]
let s:nord1 = ['#3B4252', 0]
let s:nord2 = ['#434C5E', 'NONE']
let s:nord3 = ['#4C566A', 8]
let s:nord3_5 = ['#66738e', 'NONE']
let s:nord4 = ['#D8DEE9', 'NONE']
let s:nord5 = ['#E5E9F0', 7]
let s:nord6 = ['#ECEFF4', 15]
let s:nord7 = ['#8FBCBB', 14]
let s:nord8 = ['#88C0D0', 6]
let s:nord9 = ['#81A1C1', 4]
let s:nord10 = ['#5E81AC', 12]
let s:nord11 = ['#BF616A', 1]
let s:nord12 = ['#D08770', 11]
let s:nord13 = ['#EBCB8B', 3]
let s:nord14 = ['#A3BE8C', 2]
let s:nord15 = ['#B48EAD', 5]

let s:p.normal.left = [ [ s:nord1, s:nord8, 'bold' ], [ s:nord3_5, s:nord00 ], [ s:nord3_5, s:nord00 ] ]
let s:p.normal.middle = [ [ s:nord4, s:nord00 ] ]
let s:p.normal.right = [ [ s:nord4, s:nord0 ], [ s:nord3_5, s:nord00 ], [ s:nord3_5, s:nord00 ] ]
let s:p.normal.warning = [ [ s:nord1, s:nord13, 'bold' ] ]
let s:p.normal.error = [ [ s:nord5, s:nord11, 'bold' ] ]

let s:p.inactive.left =  [ [ s:nord3, s:nord000 ] ]
let s:p.inactive.middle = [ [ s:nord3, s:nord000 ] ]

let s:p.insert.left = [ [ s:nord1, s:nord14, 'bold' ], [ s:nord3_5, s:nord00 ], [ s:nord3_5, s:nord00 ] ]
let s:p.replace.left = [ [ s:nord5, s:nord11, 'bold' ], [ s:nord3_5, s:nord00 ], [ s:nord3_5, s:nord00 ] ]
let s:p.visual.left = [ [ s:nord1, s:nord7, 'bold' ], [ s:nord3_5, s:nord00 ], [ s:nord3_5, s:nord00 ] ]

let s:p.tabline.left = [ [ s:nord5, s:nord0 ] ]
let s:p.tabline.middle = [ [ s:nord5, s:nord0 ] ]
let s:p.tabline.right = [ [ s:nord5, s:nord0 ] ]
let s:p.tabline.tabsel = [ [ s:nord1, s:nord8, 'bold' ] ]

let g:lightline#colorscheme#bti_nord#palette = lightline#colorscheme#flatten(s:p)

" Turn on bold
highlight! User1 cterm=bold ctermfg=7 ctermbg=16 gui=bold guifg=#E5E9F0 guibg=#141620

" Turn off bold
highlight! User2 ctermfg=7 ctermbg=16 guifg=#E5E9F0 guibg=#141620
