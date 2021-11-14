local nvim_lsp = require 'lspconfig'
local map = vim.api.nvim_buf_set_keymap

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
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  map(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  map(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  vim.cmd [[command! Format execute 'lua vim.lsp.buf.formatting()']]
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
  }
)

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
nvim_lsp.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.intelephense.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  trace = 'verbose',
  init_options = {
    licenceKey = os.getenv 'INTELEPHENSE_LICENCE_KEY' or '',
  },
}

nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
