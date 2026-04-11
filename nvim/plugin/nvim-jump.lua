vim.pack.add({
  { src = "https://github.com/yorickpeterse/nvim-jump" },
})

require("jump").setup({
  labels = "tnseriaogmplfuwyqbjdhvkzxc",
})

vim.keymap.set({ "n", "x", "o" }, "s", require("jump").start, {})
