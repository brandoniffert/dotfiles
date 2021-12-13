local use = require("packer").use

require("packer").startup({
  function()
    use("lewis6991/impatient.nvim")
    use("nathom/filetype.nvim")
    use("nvim-lua/plenary.nvim")
    use("wbthomason/packer.nvim")

    -- Git
    use({
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      config = function()
        require("bti.config.gitsigns")
      end,
    })
    use({
      "tpope/vim-fugitive",
      event = { "BufNew", "BufRead", "InsertEnter" },
    })

    -- Theme / UI
    use({
      "folke/tokyonight.nvim",
      config = function()
        require("bti.config.tokyonight")
      end,
    })
    use({
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("bti.config.nvim-web-devicons")
      end,
    })

    use({
      "nvim-lualine/lualine.nvim",
      event = { "BufNew", "BufRead", "InsertEnter" },
      config = function()
        require("bti.config.lualine")
      end,
    })

    -- Completion
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-path" },
        { "onsails/lspkind-nvim" },
        { "andersevenrud/cmp-tmux" },
        { "L3MON4D3/LuaSnip" },
      },
      config = function()
        require("bti.config.nvim-cmp")
      end,
    })

    -- File Explorer
    use({
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeToggle",
      config = function()
        require("bti.config.nvim-tree")
      end,
    })

    -- LSP
    use({
      "jose-elias-alvarez/null-ls.nvim",
    })

    use({
      "neovim/nvim-lspconfig",
      config = function()
        require("bti.config.lsp")
      end,
    })

    -- Fuzzy Finding
    use({
      "nvim-telescope/telescope.nvim",
      cmd = { "Telescope" },
      module = "telescope",
      requires = {
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        { "nvim-telescope/telescope-rg.nvim" },
      },
      config = function()
        require("bti.config.telescope")
      end,
    })

    use({
      "ggandor/lightspeed.nvim",
      event = "BufReadPost",
    })

    -- Treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("bti.config.nvim-treesitter")
      end,
    })
    use({
      "nvim-treesitter/playground",
      cmd = "TSHighlightCapturesUnderCursor",
    })

    -- Clipboard
    use({
      "ojroques/vim-oscyank",
      cmd = { "OSCYankReg" },
    })
    use({
      "AckslD/nvim-neoclip.lua",
      config = function()
        require("neoclip").setup()
      end,
    })

    -- Utility
    use("christoomey/vim-tmux-navigator")
    use({
      "tpope/vim-commentary",
      keys = { "gc" },
    })
    use({
      "tpope/vim-eunuch",
      event = "CmdlineEnter",
    })
    use("tpope/vim-repeat")
    use({
      "folke/which-key.nvim",
      config = function()
        require("bti.config.keys")
      end,
    })
    use({
      "wincent/loupe",
      keys = { "/", "?", "n", "N", "*", "#" },
      event = "CmdlineEnter",
    })

    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
    },
    prompt_border = "rounded",
  },
})

vim.cmd([[
  augroup PackerUserConfig
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
