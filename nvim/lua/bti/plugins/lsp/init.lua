---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    {
      "saghen/blink.cmp",
    },
    {
      "folke/lazydev.nvim",
      dependencies = {
        { "Bilal2453/luvit-meta", lazy = true },
      },
      ft = "lua",
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "lazy.nvim", words = { "Lazy" } },
        },
      },
    },
  },
  opts = function()
    return {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = false,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
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
        rust_analyzer = {},
        tailwindcss = {},
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

    -- Diagnostics
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    -- Keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("_btiLspAttach", { clear = true }),
      callback = function(event)
        local buffer = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        local map = function(modes, lhs, rhs, map_opts)
          map_opts = vim.tbl_deep_extend("force", map_opts or {}, { buffer = buffer })
          vim.keymap.set(modes, lhs, rhs, map_opts)
        end

        map("n", "<leader>cl", "<cmd>LspInfo<CR>", { desc = "Lsp Info" })
        map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
        map({ "n", "v" }, "<leader>ca", function()
          if client and client.name == "intelephense" then
            vim.lsp.buf.code_action({
              filter = function(action)
                -- Filter out PHPDoc related code actions
                return not string.match(action.title, "Add PHPDoc")
              end,
            })
          else
            vim.lsp.buf.code_action()
          end
        end, { desc = "Code Action" })
        map("n", "<leader>cF", require("bti.plugins.lsp.format").toggle, { desc = "Toggle formatting" })
        map("n", "<leader>cr", function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true, desc = "Rename" })
        map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
        map("n", "<A-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
        map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
      end,
    })

    -- Server Setup
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require("blink.cmp").get_lsp_capabilities(),
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
