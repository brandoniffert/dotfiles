local use = require('packer').use

require('packer').startup({function()
  use 'lewis6991/impatient.nvim'
  use 'nathom/filetype.nvim'
  use 'wbthomason/packer.nvim'

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    wants = 'plenary.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('bti.config.gitsigns')
    end,
  }
  use {
    'tpope/vim-fugitive',
    event = { 'BufNew', 'BufRead', 'InsertEnter' },
  }

  -- Theme / UI
  use {
    'folke/tokyonight.nvim',
    config = function()
      require('bti.config.tokyonight')
    end,
  }
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('bti.config.nvim-web-devicons')
    end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    event = { 'BufNew', 'BufRead', 'InsertEnter' },
    config = function()
      require('bti.config.lualine')
    end,
  }

  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'andersevenrud/cmp-tmux',
      'L3MON4D3/LuaSnip'
    },
    config = function()
      require('bti.config.nvim-cmp')
    end,
  }

  use {
    'onsails/lspkind-nvim'
  }

  -- File Explorer
  use {
    'kyazdani42/nvim-tree.lua',
    keys = '<Leader>\\',
    config = function()
      require('bti.config.nvim-tree')
    end,
  }

  -- LSP
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    }
  }

  use {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('bti.config.nvim-lspconfig')
    end,
  }

  -- Fuzzy Finding
  use {
    'nvim-telescope/telescope.nvim',
    keys = { '<Leader>f', '<Leader>F', '<LocalLeader>f' },
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-rg.nvim' }
    },
    config = function()
      require('bti.config.telescope')
    end,
  }

  use {
    'ggandor/lightspeed.nvim'
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    event = 'BufRead',
    config = function()
      require('bti.config.nvim-treesitter')
    end,
  }
  use {
    'nvim-treesitter/playground',
    cmd = 'TSHighlightCapturesUnderCursor'
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
  use {
    'tpope/vim-commentary',
    keys = { 'gc' }
  }
  use {
    'tpope/vim-eunuch',
    event = 'CmdlineEnter'
  }
  use 'tpope/vim-repeat'
  use 'wincent/terminus'
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }
  use {
    'wincent/loupe',
    keys = { '/', '?', 'n', 'N', '<CR>' },
    config = function()
      require('bti.config.loupe')
    end
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
