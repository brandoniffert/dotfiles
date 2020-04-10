local WinMan = require('window')
local log = require('log')

hs.window.animationDuration = 0

local keyLayout = (hs.battery.name() == nil) and 'colemak' or 'qwerty'

local colemakForQwerty = {
  r = 'a',
  t = 'd',
  w = 'q',
  x = 'z',
  p = 'e',
  v = 'c'
}

-- Meh key
local meh = {'alt', 'ctrl', 'shift'}

fastKeyStroke = function(modifiers, character)
  hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), true):post()
  hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), false):post()
end

bindMeh = function(fromKey, toKey)
  hs.hotkey.bind(meh, fromKey,
    function() fastKeyStroke({}, toKey) end,
    nil,
    function() fastKeyStroke({}, toKey) end
  )
end

bindMehFn = function(fromKey, func)
  local normalizedKey = fromKey

  if keyLayout == 'qwerty' and colemakForQwerty[fromKey] ~= nil then
    normalizedKey = colemakForQwerty[fromKey]
  end

  hs.hotkey.bind(meh, normalizedKey, func)
end

-- Put displays to sleep
bindMehFn('`', function()
  os.execute('pmset displaysleepnow')
end)

-- Reload hammerspoon config
bindMehFn('escape', function()
  hs.alert('Reloading config')

  hs.timer.doAfter(0.5, function()
    hs.reload()
  end)
end)

-- Window management
bindMehFn('r', WinMan.moveWindowLeft)
bindMehFn('t', WinMan.moveWindowRight)
bindMehFn('w', WinMan.moveWindowUpperLeft)
bindMehFn('x', WinMan.moveWindowBottomLeft)
bindMehFn('p', WinMan.moveWindowUpperRight)
bindMehFn('v', WinMan.moveWindowBottomRight)
bindMehFn('tab', WinMan.moveWindowToNextMonitor)
bindMehFn('return', WinMan.maximizeWindow)
bindMehFn('delete', WinMan.undoPop)
bindMehFn('space', WinMan.centerWindow)

-- Application watcher
function appLaunched(appName, eventType, app)
  if eventType ~= hs.application.watcher.launched then
    return
  end

  if appName == 'Alacritty' then
    local checkAppFocused = (function()
      return app:isFrontmost()
    end)

    local maximizeApp = (function()
      app:focusedWindow():setFrame(app:focusedWindow():screen():frame())
    end)

    hs.timer.waitUntil(checkAppFocused, maximizeApp, 0.1)
  end
end

appWatcher = hs.application.watcher.new(appLaunched)
appWatcher:start()
