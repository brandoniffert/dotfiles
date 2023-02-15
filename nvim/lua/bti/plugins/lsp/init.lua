return {
  -- PLUGIN: neovim/nvim-lspconfig
  -- PLUGIN: hrsh7th/cmp-nvim-lsp
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      cond = function()
        return require("bti.util").has_plugin("nvim-cmp")
      end,
    },
    opts = {
      diagnostics = {
        underline = false,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      autoformat = true,
      servers = {
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
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "hs" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
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
      },
    },
    config = function(_, opts)
      -- vim.lsp.set_log_level('debug')

      -- Diagnostics
      for name, icon in pairs(require("bti.theme").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      -- Formatting & Keymaps
      require("bti.util").on_attach(function(client, buffer)
        require("bti.plugins.lsp.format").on_attach(client, buffer)
        require("bti.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- Server Setup
      local servers = opts.servers
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
  },

  -- PLUGIN: jose-elias-alvarez/null-ls.nvim
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    init = function()
      local custom_lsp_start = vim.api.nvim_create_augroup("CustomLspStart", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Start denols",
        pattern = { "typescript" },
        group = custom_lsp_start,
        callback = function()
          require("bti.plugins.lsp.servers").launch_denols()
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Start eslint",
        pattern = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
        },
        group = custom_lsp_start,
        callback = function()
          require("bti.plugins.lsp.servers").launch_eslint()
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Start tsserver",
        pattern = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        group = custom_lsp_start,
        callback = function()
          require("bti.plugins.lsp.servers").launch_tsserver()
        end,
      })
    end,
    opts = function()
      local nls = require("null-ls")
      return {
        debounce = 150,
        save_after_format = false,
        sources = {
          nls.builtins.diagnostics.ansiblelint.with({
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
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "svelte",
              "html",
              "liquid",
            },
          }),
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },
}
