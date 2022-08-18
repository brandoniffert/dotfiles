vim.g.LoupeCenterResults = 0

return {
  "wincent/loupe",
  keys = { "/", "?", "n", "N", "*", "#" },
  event = "CmdlineEnter",
  config = function()
    vim.keymap.set("n", "<CR>", "<Plug>(LoupeClearHighlight)")
  end,
}
