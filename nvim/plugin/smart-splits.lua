vim.pack.add({
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
  { src = "https://github.com/smart-splits-nvim/backend-tmux" },
  { src = "https://github.com/rawnly/smart-splits-backend-rex" },
})

local smart_splits = require("smart-splits")

---@diagnostic disable-next-line: missing-fields
smart_splits.setup({ mux = { backend = { "smart-splits-backend-tmux", "smart-splits-backend-rex" } } })

vim.keymap.set({ "n", "t" }, "<C-h>", smart_splits.move_cursor_left, { desc = "Navigate left" })
vim.keymap.set({ "n", "t" }, "<C-j>", smart_splits.move_cursor_down, { desc = "Navigate down" })
vim.keymap.set({ "n", "t" }, "<C-k>", smart_splits.move_cursor_up, { desc = "Navigate up" })
vim.keymap.set({ "n", "t" }, "<C-l>", smart_splits.move_cursor_right, { desc = "Navigate right" })
