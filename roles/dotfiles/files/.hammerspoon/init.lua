hs.window.animationDuration = 0

local log = require 'log'

local hyper = {'cmd', 'alt', 'ctrl', 'shift'}

-- Put displays to sleep
hs.hotkey.bind(hyper, '`', function()
  os.execute('pmset displaysleepnow')
end)

-- Fullscreen current window (non-native fullscreen)
hs.hotkey.bind(hyper, 'return', function()
  local win = hs.window.focusedWindow()
  local frame = win:frame()
  local max = win:screen():frame()
  local uberscicht = hs.application.find('Übersicht')

  frame.x = max.x + 10
  frame.y = max.y + 10
  frame.w = max.w - 20
  frame.h = max.h - 20

  -- If uberscicht is running, need to adjust for the bar on the bottom of the screen
  -- The bar is 30px tall, so subtract that from the frame height
  if uberscicht ~= nil then
    frame.h = frame.h - 30 - 10
  end

  win:setFrame(frame)
end)

-- Move window between screens
local cycleScreens = hs.fnutils.cycle(hs.screen.allScreens())

hs.hotkey.bind(hyper, 'tab', function()
  hs.window.focusedWindow():moveToScreen(cycleScreens())
end)

hs.alert('Loaded Hammerspoon config')
