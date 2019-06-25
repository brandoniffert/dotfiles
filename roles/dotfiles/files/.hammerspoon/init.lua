hs.window.animationDuration = 0

local log = require 'log'

-- Hyper key
local hyper = {'cmd', 'alt', 'ctrl', 'shift'}

bindHyper = function(fromKey, toKey)
  sendKey = function()
    hs.eventtap.event.newKeyEvent({}, toKey, true):post()
  end

  hs.hotkey.bind(hyper, fromKey, sendKey, nil, sendKey)
end

bindHyperFn = function(fromKey, func)
  hs.hotkey.bind(hyper, fromKey, func)
end

bindHyper('f', 'up')
bindHyper('s', 'down')
bindHyper('r', 'left')
bindHyper('t', 'right')

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

-- Move window between screens
local cycleScreens = hs.fnutils.cycle(hs.screen.allScreens())

bindHyperFn('tab', function()
  hs.window.focusedWindow():moveToScreen(cycleScreens())
end)

hs.alert('Loaded Hammerspoon config')
