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
        FloatTitle = { fg = colors.text, bg = colors.base1 },
        LazyBackdrop = { link = "NormalFloat" },
        MiniIndentscopeSymbol = { fg = colors.surface2 },
        NormalFloat = { bg = colors.base },
        Pmenu = { bg = colors.base },
        SnacksPickerCursorLine = { bg = colors.base1 },
        SnacksPickerDir = { fg = colors.overlay1 },
        SnacksPickerListCursorLine = { bg = colors.base1 },
        SnacksPickerSelected = { bg = colors.none },
        VertSplit = { fg = colors.base1, bg = colors.none },
        WinSeparator = { fg = colors.base1, bg = colors.none },
      },
      -- https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
      integrations = {
        blink_cmp = true,
        harpoon = true,
        snacks = true,
        treesitter_context = true,
        which_key = true,
      },
    })

    vim.api.nvim_command("colorscheme catppuccin")
  end,
}
