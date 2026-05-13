vim.pack.add({ { src = "https://github.com/neovim/nvim-lspconfig" } })

vim.diagnostic.config({
  underline = false,
  update_in_insert = false,
  virtual_text = { current_line = true, spacing = 2, prefix = require("bti.theme").icons.circle },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require("bti.theme").icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = require("bti.theme").icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = require("bti.theme").icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = require("bti.theme").icons.diagnostics.Info,
    },
  },
})

local servers = {
  "ansiblels",
  "astro",
  "bashls",
  "cssls",
  "eslint",
  "intelephense",
  "jsonls",
  "lua_ls",
  "svelte",
  "tailwindcss",
  "tofu_ls",
  "vtsls",
  "yamlls",
}

for _, server in pairs(servers) do
  vim.lsp.enable(server)
end

local _document_color_enabled = false

vim.keymap.set("n", "<Leader>uc", function()
  local supported = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client:supports_method("textDocument/documentColor") then
      supported = true
      break
    end
  end

  if not supported then
    vim.notify("Document color not supported", vim.log.levels.WARN)
    return
  end

  _document_color_enabled = not _document_color_enabled
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.lsp.document_color.enable(_document_color_enabled, { bufnr = buf }, { style = "virtual" })
    end
  end
  vim.notify("Document color " .. (_document_color_enabled and "enabled" or "disabled"))
end, { desc = "Toggle Document Color" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("_bti_LspAttach", { clear = true }),
  callback = function(ev)
    vim.lsp.document_color.enable(_document_color_enabled, { bufnr = ev.buf }, { style = "virtual" })

    vim.keymap.set({ "n", "x" }, "gra", function()
      vim.lsp.buf.code_action({
        filter = function(action)
          -- Filter out PHPDoc related code actions
          return not string.match(action.title, "Add PHPDoc")
        end,
      })
    end, { desc = "Code Action" })
  end,
})
