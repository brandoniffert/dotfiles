vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("_bti_ft_help", { clear = true }),
  pattern = { "*.txt", "*.md" },
  callback = function()
    vim.cmd.wincmd("L")
    vim.cmd("vertical resize 100")
    vim.opt_local.spell = false
  end,
})
