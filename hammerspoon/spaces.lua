local M = {}

-- Store the frontmost window for each space
M.spaceFrontmostWindows = {}

-- Update the frontmost window for current space
local updateCurrentSpaceFrontmost = function()
  local currentSpace = hs.spaces.activeSpaceOnScreen()
  local win = hs.window.focusedWindow()
  if win and win:isStandard() then
    M.spaceFrontmostWindows[currentSpace] = win:id()
  end
end

-- Focus the stored window when switching spaces
local handleSpaceChange = function()
  local currentSpace = hs.spaces.activeSpaceOnScreen()
  local storedWinId = M.spaceFrontmostWindows[currentSpace]

  if storedWinId then
    local win = hs.window.get(storedWinId)
    if win then
      win:focus()
    end
  end
end

M.init = function()
  -- Watch for window focus changes to track frontmost
  local wf = hs.window.filter.new():setDefaultFilter()
  wf:subscribe({ hs.window.filter.windowFocused }, updateCurrentSpaceFrontmost)

  -- Watch for space changes
  local spaces = hs.spaces.watcher.new(handleSpaceChange)
  spaces:start()
end

return M
