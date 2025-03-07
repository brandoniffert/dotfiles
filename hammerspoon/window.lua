local M = {}

local ignoreList = {
  "com.apple.dock.helper",
  "com.apple.notificationcenterui",
  "app.loshadki.OpenIn.v4",
  "com.lowtechguys.rcmd",
  "com.runningwithcrayons.Alfred",
  "org.hammerspoon.Hammerspoon",
}

local handleWindowCounts = function()
  local apps = {}
  local bundleIds = {}

  for _, win in ipairs(hs.window.allWindows()) do
    local app = win:application()
    local appName = app:name()
    local appBundleID = app:bundleID()
    if not hs.fnutils.contains(ignoreList, appBundleID) then
      apps[appName] = (apps[appName] or 0) + 1
      bundleIds[appName] = appBundleID
    end
  end

  local sortedAppNames = {}

  for appName in pairs(apps) do
    table.insert(sortedAppNames, appName)
  end
  table.sort(sortedAppNames)

  local file = io.open("/tmp/hs-window-counts", "w")

  if file then
    for _, appName in ipairs(sortedAppNames) do
      file:write(apps[appName] .. " " .. bundleIds[appName] .. " " .. appName .. "\n")
    end
    file:close()
    hs.execute("/opt/homebrew/bin/sketchybar --trigger hs_window_change")
  else
    hs.alert.show("Failed to write to file")
  end
end

M.init = function()
  local current = io.open("/tmp/hs-window-counts", "a")

  if current then
    current:close()
  end

  local windowWatcher = hs.window.filter.new()
  windowWatcher:subscribe(hs.window.filter.windowCreated, handleWindowCounts)
  windowWatcher:subscribe(hs.window.filter.windowDestroyed, handleWindowCounts)

  handleWindowCounts()
end

return M
