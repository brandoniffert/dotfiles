return {
  -- PLUGIN: folke/trouble.nvim
  {
    "folke/trouble.nvim",
    keys = {
      { "<Leader>xx", "<cmd>TroubleToggle<CR>", desc = "Toggle" },
      { "<Leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<Leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Document diagnostics" },
      { "<Leader>xr", "<cmd>TroubleToggle lsp_references<CR>", desc = "References" },
    },
    opts = {
      use_diagnostic_signs = true,
    },
  },

  -- PLUGIN: neovim/nvim-lspconfig
  -- PLUGIN: hrsh7th/cmp-nvim-lsp
  -- PLUGIN: folke/neodev.nvim
  {
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
        denols = {
          autostart = false,
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

      local custom_lsp_start = vim.api.nvim_create_augroup("CustomLspStart", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Start denols",
        pattern = require("lspconfig.configs").denols.filetypes,
        group = custom_lsp_start,
        callback = function()
          require("bti.plugins.lsp.servers").launch_denols()
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Start tsserver",
        pattern = require("lspconfig.configs").tsserver.filetypes,
        group = custom_lsp_start,
        callback = function()
          require("bti.plugins.lsp.servers").launch_tsserver()
        end,
      })
    end,
  },

  -- PLUGIN: mfussenegger/nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
        yaml = { "yamllint" },
      }

      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
        desc = "Run linters",
        group = vim.api.nvim_create_augroup("CustomRunLinters", { clear = true }),
        callback = function()
          local lint_status, lint = pcall(require, "lint")
          if lint_status then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  -- PLUGIN: stevearc/conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          astro = { "rustywind", "prettierd" },
          css = { "prettierd" },
          graphql = { "prettierd" },
          html = { "rustywind" },
          javascript = { "rustywind", "prettierd" },
          javascriptreact = { "rustywind", "prettierd" },
          json = { "prettierd" },
          less = { "prettierd" },
          liquid = { "rustywind" },
          lua = { "stylua" },
          markdown = { "prettierd" },
          php = { "php_cs_fixer" },
          scss = { "prettierd" },
          svelte = { "rustywind" },
          typescript = { "rustywind", "prettierd" },
          typescriptreact = { "rustywind", "prettierd" },
          vue = { "rustywind" },
          yaml = { "prettierd" },
        },
        format_on_save = function(bufnr)
          local ignore_filetypes = {}

          if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
          end

          if require("bti.plugins.lsp.format").autoformat then
            return { timeout_ms = 500, lsp_fallback = true }
          end
        end,
      })
    end,
  },
}
