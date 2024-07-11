---@type LazySpec
return {
  "numToStr/Navigator.nvim",
  keys = {
    { "<C-h>", "<cmd>NavigatorLeft<CR>", mode = { "n", "t" }, desc = "Navigate left" },
    { "<C-j>", "<cmd>NavigatorDown<CR>", mode = { "n", "t" }, desc = "Navigate down" },
    { "<C-k>", "<cmd>NavigatorUp<CR>", mode = { "n", "t" }, desc = "Navigate up" },
    { "<C-l>", "<cmd>NavigatorRight<CR>", mode = { "n", "t" }, desc = "Navigate right" },
  },
  config = true,
}
