hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.loadSpoon("DateTime")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)
