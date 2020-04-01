hs.window.animationDuration = 0

local log = require 'log'

-- Hyper key
local hyper = {'cmd', 'alt', 'ctrl', 'shift'}

fastKeyStroke = function(modifiers, character)
  hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), true):post()
  hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), false):post()
end

bindHyper = function(fromKey, toKey)
  hs.hotkey.bind(hyper, fromKey,
    function() fastKeyStroke({}, toKey) end,
    nil,
    function() fastKeyStroke({}, toKey) end
  )
end

bindHyperFn = function(fromKey, func)
  hs.hotkey.bind(hyper, fromKey, func)
end

-- Put displays to sleep
bindHyperFn('`', function()
  os.execute('pmset displaysleepnow')
end)

-- Move window between screens
bindHyperFn('tab', function()
  local focusedWindow = hs.window.focusedWindow()
  focusedWindow:moveToScreen(focusedWindow:screen():next())
end)
