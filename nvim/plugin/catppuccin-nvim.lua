vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

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
    MiniJump2dSpotUnique = { bg = colors.base, fg = colors.sky, style = { "bold", "underline" } },
    TablineFill = { bg = colors.base1 },
    WinSeparator = { fg = colors.base1, bg = colors.none },
  },
  -- https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
  integrations = {
    blink_cmp = true,
    treesitter_context = true,
    which_key = true,
  },
})

vim.cmd.colorscheme("catppuccin")
