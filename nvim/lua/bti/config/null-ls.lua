local null_ls = require('null-ls')

null_ls.config({
  sources = {
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.phpcsfixer,
    null_ls.builtins.formatting.prettierd,
  }
})
