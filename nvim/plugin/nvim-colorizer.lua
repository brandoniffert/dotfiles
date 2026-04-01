vim.pack.add({
  { src = "https://github.com/catgoose/nvim-colorizer.lua" },
})

require("colorizer").setup({
  filetypes = {},
  buftype = {},
  options = {
    display = {
      mode = "virtualtext",
      virtualtext = {
        char = "",
      },
    },
  },
})

vim.keymap.set("n", "<Leader>uc", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })
