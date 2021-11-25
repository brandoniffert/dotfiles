local nvim_lsp = require 'lspconfig'

-- vim.lsp.set_log_level('debug')

-- Define how diagnostic signs are displayed
local signs = { Error = '■', Warn = '■', Hint = '■', Info = '■' }

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Setup custom on_attach function
local on_attach = function(client, bufnr)
  local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_opt('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_map('n', '<Leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_map('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_map('n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
  }
)

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Setup null-ls
local null_ls = require('null-ls')
local null_b = null_ls.builtins

null_ls.config({
  -- debug = true,
  sources = {
    null_b.diagnostics.shellcheck.with({
      diagnostics_format = "#{m} [#{c}]"
    }),
    null_b.diagnostics.yamllint,
    null_b.formatting.phpcsfixer,
    null_b.formatting.prettierd,
  }
})

-- ansible
nvim_lsp.ansiblels.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- bash
nvim_lsp.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- css
nvim_lsp.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    css = {
      validate = false
    }
  }
}

-- eslint
nvim_lsp.eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- php
nvim_lsp.intelephense.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end,
  init_options = {
    licenceKey = os.getenv 'INTELEPHENSE_LICENCE_KEY' or '',
  },
}

-- json
nvim_lsp.jsonls.setup {
  capabilities = capabilities,
  init_options = {
    provideFormatter = false
  }
}

-- null-ls
nvim_lsp['null-ls'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- python
nvim_lsp.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- tailwind
nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- javascript/typescript
nvim_lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end
}

-- yaml
nvim_lsp.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = {
        enable = true
      },
      format = {
        singleQuote = false
      }
    }
  }
}
