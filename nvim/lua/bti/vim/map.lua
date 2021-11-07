-- https://github.com/wincent/wincent/blob/a977bd6a499332254ededf732c3d71c04315f216/aspects/nvim/files/.config/nvim/lua/wincent/vim/map.lua
bti.g.map_callbacks = {}

local map = function (mode, lhs, rhs, opts)
  opts = opts or {}
  local rhs_type = type(rhs)
  if rhs_type == 'function' then
    local key = bti.util.get_key_for_fn(rhs, bti.g.map_callbacks)
    bti.g.map_callbacks[key] = rhs
    if opts.expr then
      rhs = 'v:lua.bti.g.map_callbacks.' .. key .. '()'
    else
      rhs = ':lua bti.g.map_callbacks.' .. key .. '()<CR>'
    end
  elseif rhs_type ~= 'string' then
    error('map(): unsupported rhs type: ' .. rhs_type)
  end
  local buffer = opts.buffer
  opts.buffer = nil
  if buffer == true then
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end

  return {
    dispose = function()
      if buffer == true then
        vim.api.nvim_buf_del_keymap(0, mode, lhs)
      else
        vim.api.nvim_del_keymap(mode, lhs)
      end
      bti.g.map_callbacks[key] = nil
    end,
  }
end

return map
