local use = require('packer').use

require('packer').startup({function()
  use 'lewis6991/impatient.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = [[require('bti.config.gitsigns')]]
  }
  use 'nathom/filetype.nvim'
  use 'christoomey/vim-tmux-navigator'
  use {
    'folke/tokyonight.nvim',
    config = [[require('bti.config.tokyonight')]]
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip'
    },
    config = [[require('bti.config.nvim-cmp')]]
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    keys = '<Leader>\\',
    config = [[require('bti.config.nvim-tree')]]
  }
  use {
    'neovim/nvim-lspconfig',
    event = 'BufRead',
    config = [[require('bti.config.nvim-lspconfig')]]
  }
  use {
    'nvim-lualine/lualine.nvim',
    event = { 'BufNew', 'BufRead', 'InsertEnter' },
    requires = {
      {
        'kyazdani42/nvim-web-devicons',
        config = [[require('bti.config.nvim-web-devicons')]]
      }
    },
    config = [[require('bti.config.lualine')]]
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    keys = '<Leader>',
    config = [[require('bti.config.telescope')]]
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = [[require('bti.config.nvim-treesitter')]],
    requires = { 'nvim-treesitter/playground' }
  }
  use {
    'AckslD/nvim-neoclip.lua',
    config = function()
      require('neoclip').setup()
    end
  }
  use 'tpope/vim-commentary'
  use {
    'tpope/vim-eunuch',
    event = 'CmdlineEnter'
  }
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'wbthomason/packer.nvim'
  use {
    'wincent/loupe',
    event = 'CmdlineEnter',
    config = [[require('bti.config.loupe')]]
  }
  use 'wincent/terminus'

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
