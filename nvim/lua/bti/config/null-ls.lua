local null_ls = require('null-ls')
local b = null_ls.builtins

null_ls.config({
  sources = {
    b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
    b.diagnostics.yamllint,
    b.formatting.phpcsfixer,
    b.formatting.prettierd,
  }
})
