return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = function()
    local colors = require("bti.theme").colors

    require("catppuccin").setup({
      custom_highlights = {
        FloatBorder = { fg = colors.overlay2, bg = colors.none },
        FzfLuaBorder = { link = "FloatBorder" },
        LazyBackdrop = { link = "NormalFloat" },
        LeapLabelPrimary = { fg = colors.red, bg = colors.mantle, style = { "nocombine", "bold", "underline" } },
        LeapLabelSecondary = { fg = colors.text, bg = colors.mantle, style = { "nocombine", "bold", "underline" } },
        MiniIndentscopeSymbol = { fg = colors.surface2 },
        NeoTreeIndentMarker = { fg = colors.surface2 },
        NeoTreeNormal = { bg = colors.base },
        NeoTreeNormalNC = { bg = colors.base },
        NeoTreeWinSeparator = { fg = colors.base1, bg = colors.none },
        NormalFloat = { bg = colors.base },
        Pmenu = { bg = colors.base },
        VertSplit = { fg = colors.base1, bg = colors.none },
        WinSeparator = { fg = colors.base1, bg = colors.none },
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
}
