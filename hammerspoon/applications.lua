local M = {}

local handleApp = function(appName, eventType, app)
  if eventType == hs.application.watcher.launched then
    -- Maximize Ghostty window when launched
    if appName == "Ghostty" then
      local checkAppFocused = function()
        return app:isFrontmost()
      end
      local maximizeApp = function()
        local appWindow = app:focusedWindow()
        if appWindow ~= nil then
          hs.eventtap.keyStroke({ "alt", "ctrl", "shift" }, "space")
        end
      end
      hs.timer.waitUntil(checkAppFocused, maximizeApp, 0.1)
    end
  end
end

M.init = function()
  local appWatcher = hs.application.watcher.new(handleApp)

  hs.timer.doAfter(0.2, function()
    appWatcher:start()
  end)
end

return M
