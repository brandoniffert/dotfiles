---@type LazySpec
return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = function()
    local colors = require("bti.theme").colors

    require("catppuccin").setup({
      transparent_background = true,
      float = {
        transparent = true,
        solid = false,
      },
      custom_highlights = {
        BlinkCmpMenuSelection = { link = "Cursorline" },
        MiniIndentscopeSymbol = { fg = colors.surface1 },
        SnacksPickerDir = { fg = colors.overlay2 },
        SnacksPickerFile = { bold = true },
        SnacksPickerSelected = { bg = colors.none },
        Visual = { bg = colors.surface0 },
        VisualNOS = { bg = colors.surface0 },
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
