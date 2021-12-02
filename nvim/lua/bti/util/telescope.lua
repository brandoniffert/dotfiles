local builtin = require('telescope.builtin')
local M = {}

M.find_files = function ()
  builtin.find_files {
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' }
  }
end

M.find_all_files = function ()
  builtin.find_files {
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden', '--no-ignore' }
  }
end

return M
