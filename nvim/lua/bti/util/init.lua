local M = {}

function M.has_ancestor_files(files, startpath)
  local path = startpath or vim.fs.dirname(vim.api.nvim_buf_get_name(0))

  local found = vim.fs.find(files, {
    upward = true,
    stop = vim.uv.os_homedir(),
    path = path,
  })

  return #found > 0 and found or nil
end

return M
