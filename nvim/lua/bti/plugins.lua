local M = {}

M.setup = function(needs_bootstrap)
  return require("packer").startup({
    function(use)
      use("lewis6991/impatient.nvim")
      use("wbthomason/packer.nvim")
      use("nvim-lua/plenary.nvim")
      use("nathom/filetype.nvim")

      -- Git
      use(require("bti.config.gitsigns"))
      use(require("bti.config.vim-fugitive"))

      -- Theme / UI
      use(require("bti.config.colorscheme"))
      use(require("bti.config.nvim-web-devicons"))
      use(require("bti.config.lualine"))
      use(require("bti.config.alpha"))

      -- Completion
      use(require("bti.config.completion"))

      -- File Explorer
      use(require("bti.config.nvim-tree"))

      -- LSP
      use(require("bti.config.lspconfig"))

      -- Fuzzy Finding
      use(require("bti.config.telescope"))
      use(require("bti.config.lightspeed"))

      -- Treesitter
      use(require("bti.config.nvim-treesitter"))

      -- Clipboard
      use(require("bti.config.vim-oscyank"))
      use(require("bti.config.nvim-neoclip"))

      -- Utility
      use("christoomey/vim-tmux-navigator")
      use(require("bti.config.loupe"))
      use(require("bti.config.vim-commentary"))
      use(require("bti.config.vim-eunuch"))
      use("tpope/vim-repeat")

      use({
        "folke/which-key.nvim",
        config = function()
          require("bti.config.keys")
        end,
      })

      if needs_bootstrap then
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
end

return M
