local M = {}

-- Don't do focus for these win_types
local win_type_blacklist = {
  ["popup"] = true,
}

-- Don't mess with numbers in these filetypes
local number_filetype_blacklist = {
  ["checkhealth"] = true,
  ["diff"] = true,
  ["fugitiveblame"] = true,
  ["fzf"] = true,
  ["help"] = true,
  ["lspinfo"] = true,
  ["neo-tree"] = true,
  ["qf"] = true,
}

-- Don't manage cursorline for these
local cursorline_filetype_blacklist = {}

M.focus_window = function()
  local win_type = vim.fn.win_gettype()
  local filetype = vim.bo.filetype

  if win_type_blacklist[win_type] == true then
    return
  end

  if filetype ~= "" and number_filetype_blacklist[filetype] ~= true then
    vim.wo.number = true
    vim.wo.relativenumber = true
  end

  if cursorline_filetype_blacklist[filetype] ~= true then
    vim.wo.cursorline = true
  end
end

M.blur_window = function()
  local win_type = vim.fn.win_gettype()
  local filetype = vim.bo.filetype

  if win_type_blacklist[win_type] == true then
    return
  end

  if filetype ~= "" and number_filetype_blacklist[filetype] ~= true then
    vim.wo.number = true
    vim.wo.relativenumber = false
  end

  vim.wo.cursorline = false
end

return M
