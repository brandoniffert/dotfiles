-- https://github.com/wincent/wincent/blob/a977bd6a499332254ededf732c3d71c04315f216/aspects/nvim/files/.config/nvim/lua/wincent/autoload.lua

local autoload = function(base)
  local storage = {}
  local mt = {
    __index = function(_, key)
      if storage[key] == nil then
        storage[key] = require(base .. "." .. key)
      end
      return storage[key]
    end,
  }

  return setmetatable({}, mt)
end

return autoload
