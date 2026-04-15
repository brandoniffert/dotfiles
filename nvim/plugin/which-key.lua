vim.pack.add({ { src = "https://github.com/folke/which-key.nvim" } })

require("which-key").setup({
  preset = "helix",
  delay = 500,
  show_help = false,
  show_keys = true,
  icons = {
    rules = false,
  },
  replace = {
    key = {
      { "<Space>", "SPC" },
    },
  },
  spec = {
    mode = { "n", "v" },
    { "<Leader>f", group = "find" },
    { "<leader>u", group = "util" },
    { "<leader>x", group = "trouble" },
  },
})
