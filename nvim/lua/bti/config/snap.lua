local snap = require 'snap'
local nnoremap = bti.vim.nnoremap

local vimgrep = snap.config.vimgrep:with({
  consumer = 'fzf',
  limit = 20000,
})

snap.register.command(
  'live_grep',
  vimgrep({
    producer = snap.get('producer.ripgrep.vimgrep').line({ '--smart-case', '--hidden', '--glob=!.git' }),
    prompt = 'Live Grep',
  })
)

snap.register.command(
  'live_grep_all',
  vimgrep({
    producer = snap.get('producer.ripgrep.vimgrep').line({ '--smart-case', '--hidden', '--no-ignore', '--glob=!.git' }),
    prompt = 'Live Grep All',
  })
)

nnoremap('<Leader>s', '<cmd>Snap live_grep<CR>')
nnoremap('<Leader>S', '<cmd>Snap live_grep_all<CR>')

vim.cmd [[hi link SnapBorder TelescopeBorder]]
