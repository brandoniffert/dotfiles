local map = bti.vim.map
local shallow_merge = bti.util.shallow_merge

local noremap = function (lhs, rhs, opts)
  opts = opts or {}
  map('', lhs, rhs, shallow_merge(opts, { noremap = true }))
end

return noremap
