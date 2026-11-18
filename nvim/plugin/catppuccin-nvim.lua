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
    SnacksPickerCol = { link = "NonText" },
    SnacksPickerListCursorLine = { bg = colors.base1 },
    SnacksPickerDir = { fg = colors.overlay2 },
    SnacksPickerFile = { bold = true },
    SnacksPickerSelected = { bg = colors.none },
    NeoTreeIndentMarker = { fg = colors.surface2 },
    NeoTreeNormal = { bg = colors.base },
    NeoTreeNormalNC = { bg = colors.base },
    NeoTreeWinSeparator = { fg = colors.base1, bg = colors.none },
    SmartPickPath = { fg = colors.overlay1 },
    TablineFill = { bg = colors.base1 },
    WinSeparator = { fg = colors.base1, bg = colors.none },
    RenderMarkdownH1Bg = { link = "Cursorline" },
    RenderMarkdownH2Bg = { link = "Cursorline" },
    RenderMarkdownH3Bg = { link = "Cursorline" },
    RenderMarkdownH4Bg = { link = "Cursorline" },
    RenderMarkdownH5Bg = { link = "Cursorline" },
    RenderMarkdownH6Bg = { link = "Cursorline" },
  },
  -- https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
  integrations = {
    blink_cmp = true,
    snacks = true,
    treesitter_context = true,
    which_key = true,
  },
})

vim.cmd.colorscheme("catppuccin")
