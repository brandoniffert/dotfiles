local M = {}

-- Move window to the next monitor
M.moveWindowToNextMonitor = function()
  local win = hs.window.focusedWindow()
  local currentScreen = win:screen()
  local currentFrame = currentScreen:frame()
  local windowFrame = win:frame()

  -- Get all screens and sort them by x position
  local allScreens = hs.screen.allScreens()
  table.sort(allScreens, function(a, b)
    return a:frame().x < b:frame().x
  end)

  -- Find current screen index
  local currentIdx = 0
  for i, screen in ipairs(allScreens) do
    if screen:id() == currentScreen:id() then
      currentIdx = i
      break
    end
  end

  -- Get next screen (going right first)
  local nextScreen
  if currentIdx == #allScreens then
    nextScreen = allScreens[1] -- wrap around to first screen
  else
    nextScreen = allScreens[currentIdx + 1]
  end

  local nextScreenFrame = nextScreen:frame()

  -- Set new position maintaining relative position
  windowFrame.x = ((((windowFrame.x - currentFrame.x) / currentFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
  windowFrame.y = ((((windowFrame.y - currentFrame.y) / currentFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
  windowFrame.h = ((windowFrame.h / currentFrame.h) * nextScreenFrame.h)
  windowFrame.w = ((windowFrame.w / currentFrame.w) * nextScreenFrame.w)

  win:setFrame(windowFrame)
end

return M
