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
  obj.canvas[2].text = os.date("%a %b %d %Y %H:%M")
end

function obj:init()
  local canvasW = 195
  local canvasH = 29
  local offset = 20
  local screen = hs.screen.mainScreen()
  local frame = screen:fullFrame()

  obj.canvas = hs.canvas.new({
      x = frame.w - canvasW - offset,
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
    textFont = "Source Code Pro",
    textSize = 14,
    textAlignment = "center"
  }

  if obj.timer == nil then
    obj.timer = hs.timer.doEvery(15, function() updateCanvas() end)
    obj.timer:setNextTrigger(0)
  else
    obj.timer:start()
  end
end

return obj
