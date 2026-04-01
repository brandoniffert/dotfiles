vim.pack.add({ { src = "https://github.com/folke/which-key.nvim" } })

require("which-key").setup({
  preset = "helix",
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
    { "<leader>u", group = "util" },
    { "<leader>x", group = "trouble" },
    { "[", group = "prev" },
    { "]", group = "next" },
    { "g", group = "goto" },
    { "gz", group = "surround" },
  },
})
