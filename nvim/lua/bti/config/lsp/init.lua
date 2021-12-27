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
  denols = {
    init_options = {
      enable = true,
      lint = true,
      unstable = false,
    },
    autostart = false,
  },
  eslint = {
    autostart = false,
  },
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
  tsserver = {
    autostart = false,
  },
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
  vim.cmd([[do User LspAttachBuffers]])
end

require("bti.config.lsp.null-ls").setup(options)

vim.cmd([[
  augroup CustomLspStart
    autocmd!
    autocmd FileType typescript execute 'lua require("bti.config.lsp.servers").launch_denols()'
    autocmd FileType javascript,javascriptreact,javascript.jsx,typescript,typescriptreact,typescript.tsx,vue execute 'lua require("bti.config.lsp.servers").launch_eslint()'
    autocmd FileType javascript,javascriptreact,javascript.jsx,typescript,typescriptreact,typescript.tsx execute 'lua require("bti.config.lsp.servers").launch_tsserver()'
  augroup end
]])
