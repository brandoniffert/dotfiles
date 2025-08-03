---@type vim.lsp.Config
return {
  init_options = {
    typescript = {
      tsdk = vim.fs.normalize("~/.local/lib/node_modules/typescript/lib"),
    },
  },
}
