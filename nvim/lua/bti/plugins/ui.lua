return {
  -- PLUGIN: catppuccin/nvim
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    config = function()
      local colors = require("bti.theme").colors

      require("catppuccin").setup({
        custom_highlights = {
          IndentBlanklineContextChar = { fg = colors.surface2 },
          NeoTreeNormal = { bg = colors.base },
          VertSplit = { fg = colors.base1, bg = colors.none },
        },
        integrations = {
          harpoon = true,
          leap = true,
          lsp_saga = true,
          neotree = true,
          which_key = true,
        },
      })

      vim.api.nvim_command("colorscheme catppuccin")
    end,
  },

  -- PLUGIN: kyazdani42/nvim-web-devicons
  {
    "kyazdani42/nvim-web-devicons",
    lazy = true,
  },

  -- PLUGIN: lukas-reineke/indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      show_current_context = true,
      indent_blankline_char = "│",
    },
  },

  -- PLUGIN: rebelot/heirline.nvim
  {
    "rebelot/heirline.nvim",
    config = function()
      require("bti.config.statusline").setup()
    end,
  },

  -- PLUGIN: stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
}
