local WinMan = require('window')
local log = require('log')

hs.window.animationDuration = 0

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

-- Window management
bindHyperFn('r', WinMan.moveWindowLeft)
bindHyperFn('t', WinMan.moveWindowRight)
bindHyperFn('w', WinMan.moveWindowUpperLeft)
bindHyperFn('x', WinMan.moveWindowBottomLeft)
bindHyperFn('p', WinMan.moveWindowUpperRight)
bindHyperFn('v', WinMan.moveWindowBottomRight)
bindHyperFn('tab', WinMan.moveWindowToNextMonitor)
bindHyperFn('return', WinMan.maximizeWindow)
bindHyperFn('delete', WinMan.undoPop)
bindHyperFn('space', WinMan.centerWindow)

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
