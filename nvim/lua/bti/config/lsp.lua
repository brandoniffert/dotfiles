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
  "yamlls",
}

for _, server in pairs(servers) do
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("_bti_LspAttach", { clear = true }),
  callback = function(event)
    local buffer = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local map = function(modes, lhs, rhs, map_opts)
      map_opts = vim.tbl_deep_extend("force", map_opts or {}, { buffer = buffer })
      vim.keymap.set(modes, lhs, rhs, map_opts)
    end

    map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
    map({ "n", "v" }, "<leader>ca", function()
      if client and client.name == "intelephense" then
        vim.lsp.buf.code_action({
          filter = function(action)
            -- Filter out PHPDoc related code actions
            return not string.match(action.title, "Add PHPDoc")
          end,
        })
      else
        vim.lsp.buf.code_action()
      end
    end, { desc = "Code Action" })
    map("n", "<leader>cF", require("bti.util.format").toggle, { desc = "Toggle formatting" })
    map("n", "<leader>cr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename" })
    map("n", "<A-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  end,
})
