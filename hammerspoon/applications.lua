local M = {}

M.init = function()
  local ghosttyFilter = hs.window.filter.new("Ghostty")

  ghosttyFilter:subscribe(hs.window.filter.windowCreated, function(window)
    local app = hs.application.get("Ghostty")

    if app and #app:allWindows() == 1 and window ~= nil then
      hs.eventtap.keyStroke({ "alt", "ctrl", "shift" }, "space")
    end
  end)
end

return M
