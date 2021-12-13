local M = {}

function M.setup(options)
  local nls = require("null-ls")
  local config = {
    debounce = 150,
    save_after_format = false,
    sources = {
      nls.builtins.diagnostics.ansiblelint,
      nls.builtins.diagnostics.shellcheck.with({
        diagnostics_format = "#{m} [#{c}]",
      }),
      nls.builtins.diagnostics.yamllint,
      nls.builtins.formatting.phpcsfixer,
      nls.builtins.formatting.prettierd,
      nls.builtins.formatting.rustywind.with({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "html" },
      }),
      nls.builtins.formatting.stylua,
    },
  }

  local opts = vim.tbl_deep_extend("force", config, options or {})

  nls.setup(opts)
end

function M.has_formatter(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return #available > 0
end

return M
