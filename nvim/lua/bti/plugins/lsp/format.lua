local M = {}

M.autoformat = true

function M.toggle()
  M.autoformat = not M.autoformat

  if M.autoformat then
    vim.notify("Enabled format on save")
  else
    vim.notify("Disabled format on save")
  end
end

function M.format()
  require("conform").format()
end

return M
