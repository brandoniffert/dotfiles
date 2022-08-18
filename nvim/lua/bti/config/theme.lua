vim.g.catppuccin_flavour = "mocha"

return {
  "catppuccin/nvim",
  as = "catppuccin",
  run = ":CatppuccinCompile",
  config = function()
    local colors = require("catppuccin.palettes").get_palette()
    colors.none = "NONE"

    require("catppuccin").setup({
      custom_highlights = {
        InactiveWindow = { bg = colors.mantle },
        MsgArea = { bg = colors.background },
        NvimTreeVertSplit = { fg = colors.text, bg = colors.mantle },
        SignColumn = { bg = colors.none },
        SignColumnSB = { bg = colors.none },
        GitSignsAdd = { bg = colors.none },
        GitSignsChange = { bg = colors.none },
        GitSignsDelete = { bg = colors.none },
        TabLine = { fg = colors.overlay1, bg = "#242438" },
        TabLineFill = { fg = colors.text, bg = "#242438" },
        TabLineSel = { fg = colors.text, bg = "#242438" },
        TelescopeBorder = { bg = colors.mantle },
        TelescopeNormal = { bg = colors.mantle },
        VertSplit = { fg = colors.text, bg = colors.mantle },
      },
      integrations = {
        lightspeed = true,
        which_key = true,
      },
      compile = {
        enabled = true,
      },
    })

    vim.api.nvim_command("colorscheme catppuccin")
  end,
}
