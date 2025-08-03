---@type vim.lsp.Config
return {
  init_options = {
    globalStoragePath = os.getenv("XDG_DATA_HOME") .. "/intelephense",
    licenceKey = os.getenv("INTELEPHENSE_LICENCE_KEY") or "",
  },
  single_file_support = true,
  settings = {
    intelephense = {
      environment = {
        includePaths = {
          os.getenv("XDG_CONFIG_HOME") .. "/composer/vendor/php-stubs",
        },
      },
      files = {
        maxSize = 10000000,
        exclude = {
          "**/.git/**",
          "**/node_modules/**",
        },
      },
    },
  },
}
