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

function get_window_under_mouse()
  local pos = hs.geometry.new(hs.mouse.getAbsolutePosition())
  local screen = hs.mouse.getCurrentScreen()

  return hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return screen == w:screen() and pos:inside(w:frame())
  end)
end

-- Allow moving/resizing the window under the mouse while holding CMD+Shift
-- TODO: Find out why there is considerable lag when moving the mouse
dragging_window = nil

drag_event = hs.eventtap.new(
  {
    hs.eventtap.event.types.leftMouseDragged,
    hs.eventtap.event.types.rightMouseDragged,
  }, function(e)
    if not dragging_win then return nil end

    local dx = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaX)
    local dy = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)
    local mouse = hs.mouse:getButtons()

    if mouse.left then
      dragging_win:move({dx, dy}, nil, false, 0)
    elseif mouse.right then
      local sz = dragging_win:size()
      local w1 = sz.w + dx
      local h1 = sz.h + dy
      dragging_win:setSize(w1, h1)
    end
end)

flag_event = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
  local flags = e:getFlags()

  if flags.cmd and flags.shift then
    dragging_win = get_window_under_mouse()
    drag_event:start()
  else
    draggin_win = nil
    drag_event:stop()
  end
end)

flag_event:start()
