hs.window.animationDuration = 0

local log = require 'log'

-- Hyper key
local hyper = {'cmd', 'alt', 'ctrl', 'shift'}

local function sendKey(mods, key)
  if key == nil then
    key = mods
    mods = {}
  end

  return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

bindHyper = function(fromKey, toKey)
  hs.hotkey.bind(hyper, fromKey, toKey, nil, toKey)
end

bindHyperFn = function(fromKey, func)
  hs.hotkey.bind(hyper, fromKey, func)
end

bindHyperFn('-', function()
  hs.eventtap.keyStrokes('->')
end)

bindHyperFn('=', function()
  hs.eventtap.keyStrokes('=>')
end)

-- Put displays to sleep
bindHyperFn('`', function()
  os.execute('pmset displaysleepnow')
end)

-- Get list of screens and refresh that list whenever screens are (un)plugged
local screens = hs.screen.allScreens()
local screenwatcher = hs.screen.watcher.new(function()
  screens = hs.screen.allScreens()
end)
screenwatcher:start()

-- Move window between screens
local cycleScreens = hs.fnutils.cycle(screens)

bindHyperFn('tab', function()
  hs.window.focusedWindow():moveToScreen(cycleScreens())
end)

hs.alert('Loaded Hammerspoon config')
