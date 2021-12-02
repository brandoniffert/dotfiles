local telescope = require('telescope')
local actions = require('telescope.actions')
local nnoremap = bti.vim.nnoremap

telescope.setup {
  defaults = {
    prompt_prefix = '❯ ',
    mappings = {
      i = {
        ['<C-j>'] = actions.cycle_history_next,
        ['<C-k>'] = actions.cycle_history_prev,
        ['<Esc>'] = actions.close,
      },
    }
  },
}

telescope.load_extension('fzf')
telescope.load_extension('neoclip')

nnoremap('<Leader>f', [[<cmd>lua require('bti.util.telescope').find_files()<CR>]], { silent = true })
nnoremap('<Leader>F', [[<cmd>lua require('bti.util.telescope').find_all_files()<CR>]], { silent = true })
nnoremap('<LocalLeader>fs', [[<cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<CR>]], { silent = true })
nnoremap('<LocalLeader>fS', [[<cmd>lua require('telescope.builtin').live_grep({ additional_args = function() return { '--hidden', '--no-ignore' } end })<CR>]], { silent = true })
nnoremap('<LocalLeader>fw', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { silent = true })
nnoremap('<LocalLeader>fW', [[<cmd>lua require('telescope.builtin').grep_string({ additional_args = function() return { '--hidden', '--no-ignore' } end })<CR>]], { silent = true })
nnoremap('<LocalLeader>fh', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { silent = true })
nnoremap('<LocalLeader>fH', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { silent = true })
nnoremap('<LocalLeader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { silent = true })
nnoremap('<LocalLeader>fy', [[<cmd>Telescope neoclip<CR>]], { silent = true })
