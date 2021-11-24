local nnoremap = bti.vim.nnoremap
local vnoremap = bti.vim.vnoremap

require('hop').setup({})

nnoremap('<LocalLeader>f', "<cmd>lua require'hop'.hint_words()<CR>", { silent = true })
vnoremap('<LocalLeader>f', "<cmd>lua require'hop'.hint_words()<CR>", { silent = true })
