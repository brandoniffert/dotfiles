vim.g.LoupeCenterResults = 0

return {
  "wincent/loupe",
  keys = { "/", "?", "n", "N", "*", "#" },
  event = "CmdlineEnter",
  config = function()
    local nmap = bti.vim.nmap

    nmap("<CR>", "<Plug>(LoupeClearHighlight)")
  end,
}
