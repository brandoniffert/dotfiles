---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  opts = function()
    return {
      diagnostics = {
        underline = false,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = {
          border = "single",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require("bti.theme").icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = require("bti.theme").icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = require("bti.theme").icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = require("bti.theme").icons.diagnostics.Info,
          },
        },
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      servers = {
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
          keys = {
            {
              "<leader>ca",
              function()
                vim.lsp.buf.code_action({
                  filter = function(action)
                    -- Filter out PHPDoc related code actions
                    return not string.match(action.title, "Add PHPDoc")
                  end,
                })
              end,
              desc = "Code Action",
              mode = { "n", "v" },
              has = "codeAction",
            },
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
              workspace = {
                checkThirdParty = false,
              },
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
      },
    }
  end,
  config = function(_, opts)
    -- vim.lsp.set_log_level('debug')

    -- Style adjustments
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
    })

    -- Diagnostics
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    -- Formatting & Keymaps
    require("bti.plugins.lsp.util").on_attach(function(client, buffer)
      require("bti.plugins.lsp.keymaps").on_attach(client, buffer)
    end)

    -- Server Setup
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities(),
      opts.capabilities or {}
    )

    local servers = opts.servers

    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

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
