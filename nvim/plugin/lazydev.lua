vim.pack.add({
  { src = "https://github.com/Bilal2453/luvit-meta" },
  { src = "https://github.com/folke/lazydev.nvim" },
})

require("lazydev").setup({
  library = {
    { path = "luvit-meta/library", words = { "vim%.uv" } },
    { path = "snacks.nvim", words = { "Snacks" } },
  },
})
