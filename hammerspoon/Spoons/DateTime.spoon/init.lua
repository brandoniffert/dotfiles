--- === DateTime ===
---
--- Add date and time to the desktop

local obj={}
obj.__index = obj

-- Metadata
obj.name = "DateTime"
obj.version = "1.0"
obj.author = "Brandon Iffert"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local function updateCanvas()
  obj.canvas[2].text = os.date("%H:%M %a %b %d")
end

function obj:init()
  local canvasW = 155
  local canvasH = 30
  local offset = 20
  local screen = hs.screen.mainScreen()
  local frame = screen:fullFrame()
  local numScreens = #hs.screen.allScreens()
  local canvasX = numScreens > 1 and (frame.w + offset) or offset

  obj.canvas = hs.canvas.new({
      x = canvasX,
      y = frame.h - canvasH - offset,
      w = canvasW,
      h = canvasH
    }):show()

  obj.canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
  obj.canvas:level(hs.canvas.windowLevels.desktopIcon)

  obj.canvas[1] = {
    type = "rectangle",
    action = "fill",
    fillColor = {hex="#000000", alpha=0.3}
  }

  obj.canvas[2] = {
    type = "text",
    text = "",
    textFont = "Inconsolata LGC",
    textSize = 14,
    textAlignment = "center",
    frame = {
      x = 0,
      y = 4,
      w = "100%",
      h = "100%"
    }
  }

  if obj.timer == nil then
    obj.timer = hs.timer.doEvery(5, function() updateCanvas() end)
    obj.timer:setNextTrigger(0)
  else
    obj.timer:start()
  end
end

return obj
