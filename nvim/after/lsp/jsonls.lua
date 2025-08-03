---@type vim.lsp.Config
return {
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "composer.json" },
          url = "https://getcomposer.org/schema.json",
        },
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig",
        },
      },
    },
  },
}
