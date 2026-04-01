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

-- Snacks Explorer is technically a floating window which messes with the edge logic of Navigator in tmux
-- If focused inside a Snacks Explorer picker, we should always move to the left pane in tmux
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "snacks_picker_list" },
  callback = function()
    vim.keymap.set("n", "<C-h>", function()
      if vim.env.TMUX then
        vim.fn.system("tmux select-pane -L")
      else
        vim.cmd("NavigatorLeft")
      end
    end, { buffer = true })
  end,
})
