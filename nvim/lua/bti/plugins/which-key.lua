---@type LazySpec
return {
  "folke/which-key.nvim",
  ---@class wk.Opts
  opts = {
    preset = "modern",
    delay = 500,
    show_help = false,
    show_keys = true,
    icons = {
      breadcrumb = "•",
      separator = "•",
      group = "",
      rules = false,
    },
    replace = {
      key = {
        { "<Space>", "SPC" },
      },
    },
    spec = {
      mode = { "n", "v" },
      { "<Leader>c", group = "code" },
      { "<Leader>f", group = "find" },
      { "<Leader>h", group = "harpoon" },
      { "<leader>u", group = "util" },
      { "<leader>x", group = "trouble" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gz", group = "surround" },
    },
  },
}
