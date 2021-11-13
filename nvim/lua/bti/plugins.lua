local use = require('packer').use

require('packer').startup({function()
  use 'lewis6991/impatient.nvim'
  use 'nathom/filetype.nvim'
  use 'wbthomason/packer.nvim'

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = [[require('bti.config.gitsigns')]]
  }
  use 'tpope/vim-fugitive'

  -- Theme
  use {
    'folke/tokyonight.nvim',
    config = [[require('bti.config.tokyonight')]]
  }
  use {
    'kyazdani42/nvim-web-devicons',
    config = [[require('bti.config.nvim-web-devicons')]]
  }

  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      { 'andersevenrud/compe-tmux', branch = 'cmp' },
      'L3MON4D3/LuaSnip'
    },
    config = [[require('bti.config.nvim-cmp')]]
  }

  -- File Explorer
  use {
    'kyazdani42/nvim-tree.lua',
    keys = '<Leader>\\',
    config = [[require('bti.config.nvim-tree')]]
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    event = 'BufRead',
    config = [[require('bti.config.nvim-lspconfig')]]
  }

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    event = { 'BufNew', 'BufRead', 'InsertEnter' },
    config = [[require('bti.config.lualine')]]
  }

  -- Fuzzy Finding
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-live-grep-raw.nvim' }
    },
    keys = '<Leader>',
    config = [[require('bti.config.telescope')]]
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = [[require('bti.config.nvim-treesitter')]],
    requires = { 'nvim-treesitter/playground' }
  }

  -- Clipboard
  use 'ojroques/vim-oscyank'
  use {
    'AckslD/nvim-neoclip.lua',
    config = function()
      require('neoclip').setup()
    end
  }

  -- Utility
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-commentary'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-repeat'
  use 'wincent/terminus'
  use {
    'wincent/loupe',
    config = [[require('bti.config.loupe')]]
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end
  },
  prompt_border = 'rounded'
}})

vim.cmd([[
  augroup PackerUserConfig
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
