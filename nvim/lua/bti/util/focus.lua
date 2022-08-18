local M = {}

local winhighlight_blurred = table.concat({
  "EndOfBuffer:InactiveWindow",
  "IncSearch:InactiveWindow",
  "Normal:InactiveWindow",
  "NormalNC:InactiveWindow",
  "Search:InactiveWindow",
  "SignColumn:InactiveWindow",
}, ",")

-- Don't use 'winhighlight' to make these filetypes seem blurred
local winhighlight_filetype_blacklist = {
  ["NvimTree"] = true,
  ["diff"] = true,
  ["fugitiveblame"] = true,
  ["lspinfo"] = true,
  ["packer"] = true,
  ["qf"] = true,
}

-- Force 'list' (when `true`) or 'nolist' (when `false`) for these
local list_filetypes = {
  ["help"] = false,
  ["lspinfo"] = false,
}

-- Don't mess with numbers in these filetypes
local number_blacklist = {
  ["NvimTree"] = true,
  ["diff"] = true,
  ["fugitiveblame"] = true,
  ["help"] = true,
  ["lspinfo"] = true,
  ["qf"] = true,
}

-- Don't mess with 'conceallevel' for these
local conceallevel_filetypes = {
  ["help"] = 2,
  ["json"] = 0,
}

-- Don't manage cursorline for these
local cursorline_filetype_blacklist = {}

M.focus_window = function()
  local filetype = vim.bo.filetype

  -- Turn on relative numbers, unless user has explicitly changed numbering.
  if filetype ~= "" and number_blacklist[filetype] ~= true then
    vim.wo.number = true
    vim.wo.relativenumber = true
  end

  if winhighlight_filetype_blacklist[filetype] ~= true then
    vim.wo.winhighlight = ""
  end

  if filetype ~= "" and cursorline_filetype_blacklist[filetype] ~= true then
    vim.wo.cursorline = true
  end

  if filetype == "" then
    vim.wo.list = true
  else
    local list = list_filetypes[filetype]
    vim.wo.list = list == nil and true or list
  end

  local conceallevel = conceallevel_filetypes[filetype] or 2
  vim.wo.conceallevel = conceallevel

  require("bti.statusline").activate()
end

M.blur_window = function()
  local filetype = vim.bo.filetype

  if filetype ~= "" and number_blacklist[filetype] ~= true then
    vim.wo.number = true
    vim.wo.relativenumber = false
  end

  if filetype == "" or winhighlight_filetype_blacklist[filetype] ~= true then
    vim.wo.winhighlight = winhighlight_blurred
  end

  if filetype ~= "" and cursorline_filetype_blacklist[filetype] ~= true then
    vim.wo.cursorline = false
  end

  if filetype == "" then
    vim.wo.list = false
  else
    local list = list_filetypes[filetype]
    if list == nil then
      vim.wo.list = false
    else
      vim.wo.list = list
    end
  end

  if filetype == "" or conceallevel_filetypes[filetype] == nil then
    vim.wo.conceallevel = 0
  end

  require("bti.statusline").deactivate()
end

return M
