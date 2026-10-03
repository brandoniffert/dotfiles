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

local herdr_ttys = { list = {}, at = nil }

local function herdr_client_ttys()
  local now = vim.uv.now()
  if herdr_ttys.at and now - herdr_ttys.at < 10000 then
    return herdr_ttys.list
  end

  local list = {}
  for _, line in ipairs(vim.fn.systemlist({ "ps", "-axo", "tty=,comm=" })) do
    local tty, comm = line:match("^%s*(%S+)%s+(.-)%s*$")
    if tty and tty ~= "??" and tty ~= "?" and vim.fs.basename(comm) == "herdr" then
      table.insert(list, "/dev/" .. tty)
    end
  end

  herdr_ttys.list, herdr_ttys.at = list, now
  return list
end

function M.osc(seq)
  if os.getenv("TMUX") then
    vim.api.nvim_ui_send(string.format("\x1bPtmux;\x1b%s\x1b\\", seq))
  elseif os.getenv("HERDR_ENV") then
    -- herdr swallows some OSCs (e.g. 9;4); write straight to the client tty
    for _, path in ipairs(herdr_client_ttys()) do
      local f = io.open(path, "w")
      if f then
        f:write(seq)
        f:close()
      end
    end
  else
    vim.api.nvim_ui_send(seq)
  end
end

return M
