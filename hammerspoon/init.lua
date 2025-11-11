-- local log = require("log")

require("hs.ipc")

hs.window.animationDuration = 0
hs.application.enableSpotlightForNameSearches(true)

local detectKeyLayout = function()
  for _, device in ipairs(hs.usb.attachedDevices()) do
    if device.vendorName == "ZSA" then
      return "colemak"
    end
  end

  return "qwerty"
end

local keyLayout = detectKeyLayout()

hs.usb.watcher
  .new(function(device)
    if device.vendorName == "ZSA" and device.eventType == "added" then
      keyLayout = "colemak"
    end

    if device.vendorName == "ZSA" and device.eventType == "removed" then
      keyLayout = "qwerty"
    end
  end)
  :start()

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

local bindMehFn = function(fromKey, func)
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

-- Reload hammerspoon config
bindMehFn("escape", function()
  hs.alert("Reloading config")

  hs.timer.doAfter(0.5, function()
    hs.reload()
  end)
end)

-- Sketchybar windows
require("window").init()

-- Application watcher
require("applications").init()

-- Spaces
-- require("spaces").init()
