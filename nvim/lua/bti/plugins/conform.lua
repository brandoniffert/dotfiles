---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      astro = { "rustywind", "prettierd" },
      css = { "prettierd" },
      graphql = { "prettierd" },
      html = { "rustywind" },
      javascript = { "rustywind", "prettierd" },
      javascriptreact = { "rustywind", "prettierd" },
      json = { "prettierd" },
      less = { "prettierd" },
      liquid = { "rustywind", "prettierd" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      php = function()
        local has_php_cs_fixer_config = require("bti.util").has_ancestor_files({
          ".php-cs-fixer.dist.php",
        })

        local has_php_cs_config = require("bti.util").has_ancestor_files({
          "phpcs.xml.dist",
        })

        if has_php_cs_fixer_config then
          return { "php_cs_fixer" }
        end

        if has_php_cs_config then
          return { "phpcbf" }
        end

        return { "php_cs_fixer" }
      end,
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
  },
}
