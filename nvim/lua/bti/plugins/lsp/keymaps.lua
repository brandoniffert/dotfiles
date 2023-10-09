local M = {}

local k = vim.keymap.set

function M.on_attach(_, buffer)
  k("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics", buffer = buffer })
  k("n", "<leader>cl", "<cmd>LspInfo<CR>", { desc = "Lsp Info", buffer = buffer })
  k({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", buffer = buffer })
  k({ "n", "v" }, "<leader>cf", require("bti.plugins.lsp.format").format, { desc = "Format", buffer = buffer })
  k("n", "<leader>cF", require("bti.plugins.lsp.format").toggle, { desc = "Toggle formatting", buffer = buffer })
  k("n", "<leader>cr", M.rename, { desc = "Rename", buffer = buffer, expr = true })
  k("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "Goto Definition", buffer = buffer })
  k("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", { desc = "Goto Implementation", buffer = buffer })
  k("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "References", buffer = buffer })
  k("n", "gt", "<cmd>FzfLua lsp_typedefs<CR>", { desc = "Goto Type Definition", buffer = buffer })
  k("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = buffer })
  k("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = buffer })
  k("n", "]d", M.diagnostic_goto(true), { desc = "Next Diagnostic", buffer = buffer })
  k("n", "[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic", buffer = buffer })
  k("n", "]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error", buffer = buffer })
  k("n", "[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error", buffer = buffer })
  k("n", "]w", M.diagnostic_goto(true, "WARN"), { desc = "Next Warning", buffer = buffer })
  k("n", "[w", M.diagnostic_goto(false, "WARN"), { desc = "Prev Warning", buffer = buffer })
end

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand("<cword>")
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
