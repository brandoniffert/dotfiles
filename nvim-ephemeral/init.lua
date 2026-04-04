vim.g.mapleader = " "

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.shadafile = "NONE"
vim.env.NVIM_LOG_FILE = "/dev/null"

vim.keymap.set("n", "<Leader>q", "<cmd>:q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<Leader>Q", "<cmd>:q!<CR>", { desc = "Quit without saving" })

vim.keymap.set("v", "<Leader>y", '"*y', { desc = "Yank to clipboard" })

vim.pack.add({ { src = "https://github.com/stevearc/oil.nvim" } })
require("oil").setup({})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    local base_dirs = {
      vim.fn.stdpath("state"),
      vim.fn.stdpath("cache"),
    }
    for _, dir in ipairs(base_dirs) do
      vim.notify(dir)
      vim.fn.delete(dir, "rf")
    end
  end,
})
