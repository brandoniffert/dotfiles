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
  "tailwindcss",
  "tofu_ls",
  "vtsls",
  "yamlls",
}

for _, server in pairs(servers) do
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("_bti_LspAttach", { clear = true }),
  callback = function()
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
