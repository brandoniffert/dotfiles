---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
      diagnostics = {
        globals = { "hs" },
      },
    },
  },
}
