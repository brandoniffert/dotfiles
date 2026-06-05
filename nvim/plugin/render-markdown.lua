vim.pack.add({
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
  heading = { icons = {} },
})
