return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
    },
    {
      "folke/neodev.nvim",
      config = true,
    },
  },
  config = function()
    -- vim.lsp.set_log_level('debug')

    -- Diagnostics
    for name, icon in pairs(require("bti.theme").icons.diagnostics) do
      name = "DiagnosticSign" .. name
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    vim.diagnostic.config({
      underline = false,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = "●" },
      severity_sort = true,
      float = {
        border = "single",
      },
    })

    -- Formatting & Keymaps
    require("bti.util").on_attach(function(client, buffer)
      require("bti.plugins.lsp.keymaps").on_attach(client, buffer)
    end)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
    })

    -- Server Setup
    local servers = {
      ansiblels = {},
      astro = {
        init_options = {
          typescript = {
            tsdk = vim.fs.normalize("~/.local/lib/node_modules/typescript/lib"),
          },
        },
      },
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
          globalStoragePath = os.getenv("XDG_DATA_HOME") .. "/intelephense",
          licenceKey = os.getenv("INTELEPHENSE_LICENCE_KEY") or "",
        },
      },
      jsonls = {
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
      },
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "hs" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      },
      pyright = {},
      rust_analyzer = {},
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

    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    local function setup(server)
      local server_opts = servers[server] or {}
      server_opts.capabilities = capabilities

      require("lspconfig")[server].setup(server_opts)
    end

    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        setup(server)
      end
    end
  end,
}
