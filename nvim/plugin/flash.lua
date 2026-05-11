vim.pack.add({ { src = "https://github.com/folke/flash.nvim" } })

require("flash").setup({
  modes = {
    char = {
      autohide = true,
      jump_labels = true,
      multi_line = false,
      jump = {
        autojump = true,
      },
    },
  },
  jump = {
    autojump = true,
    nohlsearch = true,
  },
})

vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash (Treesitter)" })

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Flash (Remote)" })

vim.keymap.set({ "x", "o" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Flash (Treesitter Search)" })
