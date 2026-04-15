vim.pack.add({
  { src = "https://github.com/numToStr/Navigator.nvim" },
})

require("Navigator").setup({
  auto_save = nil,
  disable_on_zoom = false,
  mux = "auto",
})

vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>NavigatorLeft<CR>", { desc = "Navigate left" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>NavigatorDown<CR>", { desc = "Navigate down" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>NavigatorUp<CR>", { desc = "Navigate up" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>NavigatorRight<CR>", { desc = "Navigate right" })
