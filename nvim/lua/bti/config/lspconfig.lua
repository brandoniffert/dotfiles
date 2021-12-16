return {
  "neovim/nvim-lspconfig",
  requires = {
    "jose-elias-alvarez/null-ls.nvim",
  },
  event = { "InsertEnter" },
  config = function()
    require("bti.config.lsp")
  end,
}
