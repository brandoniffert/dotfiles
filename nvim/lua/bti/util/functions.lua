local M = {}

function M.replace_fancy_characters()
  local chars = {
    ["“"] = '"',
    ["”"] = '"',
    ["‘"] = "'",
    ["’"] = "'",
    ["…"] = "...",
  }

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local function replace_char(line)
    for smart, normal in pairs(chars) do
      line = line:gsub(smart, normal)
    end
    return line
  end

  for i, line in ipairs(lines) do
    lines[i] = replace_char(line)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

function M.strip_whitespace()
  local saved_view = vim.fn.winsaveview()

  vim.api.nvim_command([[%s/\v\s+$//e]])
  vim.api.nvim_command("retab")
  vim.fn.winrestview(saved_view)
end

function M.split_at()
  local ok, splitjoin = pcall(require, "mini.splitjoin")
  if ok then
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = pos[1]
    local col = pos[2]

    splitjoin.split_at({ { line = line, col = col } })
  else
    vim.notify("mini.splitjoin is not installed", vim.log.levels.ERROR)
  end
end

return M
