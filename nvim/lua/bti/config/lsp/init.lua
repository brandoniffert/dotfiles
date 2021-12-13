require("bti.config.lsp.diagnostics").setup()

-- vim.lsp.set_log_level('debug')

local function on_attach(client, bufnr)
  require("bti.config.lsp.formatting").setup(client, bufnr)
  require("bti.config.lsp.keys").setup(client, bufnr)
  require("bti.config.lsp.completion").setup(client, bufnr)
end

local servers = {
  bashls = {},
  cssls = {
    settings = {
      css = {
        validate = false,
      },
    },
  },
  eslint = {},
  intelephense = {
    init_options = {
      licenceKey = os.getenv("INTELEPHENSE_LICENCE_KEY") or "",
    },
  },
  jsonls = {
    init_options = {
      provideFormatter = false,
    },
  },
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "hs" },
        },
      },
    },
  },
  pyright = {},
  tailwindcss = {},
  tsserver = {},
  yamlls = {
    settings = {
      yaml = {
        format = {
          singleQuote = false,
        },
      },
    },
  },
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

for server, config in pairs(servers) do
  local opts = vim.tbl_deep_extend("force", options, config or {})

  require("lspconfig")[server].setup(opts)
  vim.cmd([[ do User LspAttachBuffers ]])
end

require("bti.config.lsp.null-ls").setup(options)
