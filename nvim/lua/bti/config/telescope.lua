local nnoremap = bti.vim.nnoremap
local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    prompt_prefix = '❯ ',
    mappings = {
      i = {
        ['<C-j>'] = actions.cycle_history_next,
        ['<C-k>'] = actions.cycle_history_prev
      },
    },
    file_ignore_patterns = {
      '^.git/'
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    }
  }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('neoclip')

nnoremap('<Leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { silent = true })
nnoremap('<Leader>f', [[<cmd>lua require('telescope.builtin').find_files({ hidden = true })<CR>]], { silent = true })
nnoremap('<Leader>F', [[<cmd>lua require('telescope.builtin').find_files({ hidden = true, no_ignore = true })<CR>]], { silent = true })
nnoremap('<Leader>H', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { silent = true })
nnoremap('<Leader>h', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { silent = true })
nnoremap('<Leader>s', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { silent = true })
nnoremap('<Leader>S', [[<cmd>lua require('telescope.builtin').live_grep({ additional_args = function() return { '--hidden', '--no-ignore' } end })<CR>]], { silent = true })
nnoremap('<LocalLeader>s', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { silent = true })
nnoremap('<LocalLeader>S', [[<cmd>lua require('telescope.builtin').grep_string({ additional_args = function() return { '--hidden', '--no-ignore' } end })<CR>]], { silent = true })
nnoremap('<LocalLeader>y', [[<cmd>Telescope neoclip<CR>]], { silent = true })
