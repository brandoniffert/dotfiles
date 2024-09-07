---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
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
          single_file_support = true,
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
        ts_ls = {},
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
    require("lspconfig.ui.windows").default_options.border = "single"
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
    })

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
        map("n", "<leader>cr", ":IncRename " .. vim.fn.expand("<cword>"), { expr = true, desc = "Rename" })
        map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
        map("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "Goto Definition" })
        map("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", { desc = "Goto Implementation" })
        map("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "References" })
        map("n", "gt", "<cmd>FzfLua lsp_typedefs<CR>", { desc = "Goto Type Definition" })
        map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
        map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
      end,
    })

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
