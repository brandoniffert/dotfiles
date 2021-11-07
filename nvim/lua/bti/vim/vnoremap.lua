local map = bti.vim.map
local shallow_merge = bti.util.shallow_merge

local vnoremap = function (lhs, rhs, opts)
  opts = opts or {}
  map('v', lhs, rhs, shallow_merge(opts, { noremap = true }))
end

return vnoremap
