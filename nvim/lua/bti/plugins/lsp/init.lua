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
        cond = function()
          return require("bti.util").has_plugin("nvim-cmp")
        end,
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
        require("bti.plugins.lsp.format").on_attach(client, buffer)
        require("bti.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
      })

      -- Server Setup
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

  -- PLUGIN: jose-elias-alvarez/null-ls.nvim
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    opts = function()
      local nls = require("null-ls")
      return {
        debounce = 150,
        save_after_format = false,
        sources = {
          nls.builtins.diagnostics.ansiblelint.with({
            filetypes = { "yaml" },
            condition = function(utils)
              return utils.root_has_file({ ".ansible-lint" })
            end,
          }),
          nls.builtins.diagnostics.shellcheck.with({
            diagnostics_format = "#{m} [#{c}]",
          }),
          nls.builtins.diagnostics.yamllint,
          nls.builtins.formatting.phpcsfixer,
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.rustywind.with({
            extra_filetypes = {
              "liquid",
            },
          }),
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },
}
