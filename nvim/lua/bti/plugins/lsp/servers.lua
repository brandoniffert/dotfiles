local root_pattern = require("lspconfig").util.root_pattern

local M = {}

M.launch_denols = function()
  local root_dir = root_pattern("deno.json")

  if root_dir(vim.api.nvim_buf_get_name(0)) then
    vim.cmd("LspStart denols")
  end
end

M.launch_tsserver = function()
  local root_dir = root_pattern("package.json")

  if root_dir(vim.api.nvim_buf_get_name(0)) then
    vim.cmd("LspStart tsserver")
  end
end

return M
