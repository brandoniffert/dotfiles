local WinMan = require("window")
local log = require("log")

hs.window.animationDuration = 0

local detectKeyLayout = function()
  for _, device in ipairs(hs.usb.attachedDevices()) do
    if device.vendorName == "ZSA" then
      return "colemak"
    end
  end

  return "qwerty"
end

local keyLayout = detectKeyLayout()

hs.usb.watcher.new(function(device)
  if device.vendorName == "ZSA" and device.eventType == "added" then
    keyLayout = "colemak"
  end

  if device.vendorName == "ZSA" and device.eventType == "removed" then
    keyLayout = "qwerty"
  end
end):start()

local colemakForQwerty = {
  r = "a",
  t = "d",
  w = "q",
  x = "z",
  p = "e",
  v = "c",
}

-- Meh key
local meh = { "alt", "ctrl", "shift" }

fastKeyStroke = function(modifiers, character)
  hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), true):post()
  hs.eventtap.event.newKeyEvent(modifiers, string.lower(character), false):post()
end

bindMeh = function(fromKey, toKey)
  hs.hotkey.bind(
    meh,
    fromKey,
    function()
      fastKeyStroke({}, toKey)
    end,
    nil,
    function()
      fastKeyStroke({}, toKey)
    end
  )
end

bindMehFn = function(fromKey, func)
  local normalizedKey = fromKey

  if keyLayout == "qwerty" and colemakForQwerty[fromKey] ~= nil then
    normalizedKey = colemakForQwerty[fromKey]
  end

  hs.hotkey.bind(meh, normalizedKey, func)
end

-- Put displays to sleep
bindMehFn("`", function()
  os.execute("pmset displaysleepnow")
end)

-- Set all displays to max brightness
bindMehFn("b", function()
  for _, screen in pairs(hs.screen.allScreens()) do
    screen:setBrightness(0.5)
    hs.timer.doAfter(0.5, function()
      screen:setBrightness(1)
    end)
  end
end)

-- Reload hammerspoon config
bindMehFn("escape", function()
  hs.alert("Reloading config")

  hs.timer.doAfter(0.5, function()
    hs.reload()
  end)
end)

-- Window management
bindMehFn("r", WinMan.moveWindowLeft)
bindMehFn("t", WinMan.moveWindowRight)
bindMehFn("w", WinMan.moveWindowUpperLeft)
bindMehFn("x", WinMan.moveWindowBottomLeft)
bindMehFn("p", WinMan.moveWindowUpperRight)
bindMehFn("v", WinMan.moveWindowBottomRight)
bindMehFn("tab", WinMan.moveWindowToNextMonitor)
bindMehFn("space", WinMan.maximizeWindow)
bindMehFn("delete", WinMan.undoPop)
bindMehFn("=", WinMan.centerWindow)

-- Application watcher
function handleApp(appName, eventType, app)
  if eventType == hs.application.watcher.launched then
    -- Set Chrome as default browser when launched
    if appName == "Google Chrome" then
      hs.execute("defaultbrowser chrome && confirm-use-dialog", true)
    end
  end

  if eventType == hs.application.watcher.terminated then
    -- Set Firefox as default browser when Chrome is closed
    if appName == "Google Chrome" then
      hs.execute("defaultbrowser firefox && confirm-use-dialog", true)
    end
  end
end

appWatcher = hs.application.watcher.new(handleApp)
appWatcher:start()
