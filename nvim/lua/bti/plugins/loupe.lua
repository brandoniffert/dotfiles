return {
  "wincent/loupe",
  init = function()
    vim.g.LoupeCenterResults = 0
    vim.g.LoupeClearHighlightMap = 0
  end,
  config = function()
    vim.keymap.set("n", "<LocalLeader><CR>", "<Plug>(LoupeClearHighlight)", { desc = "Clear search highlight" })
  end,
}
