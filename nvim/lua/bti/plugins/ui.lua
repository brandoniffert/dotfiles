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
          IblIndent = { fg = colors.surface0 },
          IblScope = { fg = colors.surface2 },
          FloatBorder = { fg = colors.overlay2 },
          FzfLuaBorder = { link = "FloatBorder" },
          LeapLabelPrimary = { fg = colors.red, bg = colors.mantle, style = { "nocombine", "bold", "underline" } },
          LeapLabelSecondary = { fg = colors.text, bg = colors.mantle, style = { "nocombine", "bold", "underline" } },
          NeoTreeNormal = { bg = colors.base },
          NormalFloat = { bg = colors.base },
          Pmenu = { bg = colors.base },
          VertSplit = { fg = colors.base1, bg = colors.none },
        },
        integrations = {
          harpoon = true,
          leap = true,
          neotree = true,
          treesitter_context = true,
          which_key = true,
        },
      })

      vim.api.nvim_command("colorscheme catppuccin")
    end,
  },

  -- PLUGIN: kyazdani42/nvim-web-devicons
  {
    "kyazdani42/nvim-web-devicons",
  },

  -- PLUGIN: lukas-reineke/indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      scope = {
        show_start = false,
      },
    },
    main = "ibl",
  },

  -- PLUGIN: NvChad/nvim-colorizer.lua
  {
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    keys = {
      { "<Leader>uc", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" },
    },
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile", "!popup" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = false,
        rgb_fn = true,
        hsl_fn = true,
        css = false,
        css_fn = true,
        mode = "virtualtext",
        virtualtext = "",
      },
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
