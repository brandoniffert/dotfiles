---@type LazySpec
return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = function()
    local colors = require("bti.theme").colors

    require("catppuccin").setup({
      float = {
        transparent = true,
        solid = false,
      },
      custom_highlights = {
        MiniIndentscopeSymbol = { fg = colors.surface2 },
        Pmenu = { bg = colors.base },
        PmenuSel = { bg = colors.surface0 },
        SnacksPickerDir = { fg = colors.overlay2 },
        SnacksPickerFile = { bold = true },
        SnacksPickerSelected = { bg = colors.none },
        VertSplit = { fg = colors.base1, bg = colors.none },
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
