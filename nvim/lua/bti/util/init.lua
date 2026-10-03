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

function M.osc(seq)
  if os.getenv("TMUX") then
    vim.api.nvim_ui_send(string.format("\x1bPtmux;\x1b%s\x1b\\", seq))
  else
    vim.api.nvim_ui_send(seq)
  end
end

return M
