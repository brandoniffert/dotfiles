---@type LazySpec
return {
  "catgoose/nvim-colorizer.lua",
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
}
