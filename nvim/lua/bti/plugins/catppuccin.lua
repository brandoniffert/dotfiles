---@type LazySpec
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
        FzfLuaHeaderText = { fg = colors.red },
        LazyBackdrop = { link = "NormalFloat" },
        LeapBackdrop = { fg = colors.overlay0 },
        LeapLabel = { fg = colors.red, bg = colors.none, style = { "nocombine", "bold", "underline" } },
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
      -- https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
      integrations = {
        blink_cmp = true,
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
