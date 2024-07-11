return {
  "wincent/loupe",
  init = function()
    vim.g.LoupeCenterResults = 0
    vim.g.LoupeClearHighlightMap = 0
  end,
  config = function()
    vim.keymap.set("n", "<CR>", function()
      vim.cmd([[execute "normal! \<Plug>(LoupeClearHighlight)"]])
      vim.cmd("echo")
    end, { desc = "Clear search highlight" })
  end,
}
