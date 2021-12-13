hs.grid.MARGINX = hs.screen.primaryScreen():frame().w * 0.02
hs.grid.MARGINY = hs.screen.primaryScreen():frame().w * 0.02
hs.grid.setGrid("12x12")

local WinMan = {}

WinMan.undo = {}

-- Move window to the left half
function WinMan.moveWindowLeft()
  local win = hs.window.focusedWindow()

  WinMan.undoPush()
  hs.grid.set(win, "0,0 6x12")
end

-- Move window to the right half
function WinMan.moveWindowRight()
  local win = hs.window.focusedWindow()

  WinMan.undoPush()
  hs.grid.set(win, "6,0 6x12")
end

-- Move window to the upper left
function WinMan.moveWindowUpperLeft()
  local win = hs.window.focusedWindow()

  WinMan.undoPush()
  hs.grid.set(win, "0,0 6x6")
end

-- Move window to the upper right
function WinMan.moveWindowUpperRight()
  local win = hs.window.focusedWindow()

  WinMan.undoPush()
  hs.grid.set(win, "6,0 6x6")
end

-- Move window to the bottom left
function WinMan.moveWindowBottomLeft()
  local win = hs.window.focusedWindow()

  WinMan.undoPush()
  hs.grid.set(win, "0,6 6x6")
end

-- Move window to the bottom right
function WinMan.moveWindowBottomRight()
  local win = hs.window.focusedWindow()

  WinMan.undoPush()
  hs.grid.set(win, "6,6 6x6")
end

-- Maximize window
function WinMan.maximizeWindow()
  local win = hs.window.focusedWindow()
  local screenDimensions = WinMan.getScreenDimensions()

  WinMan.undoPush()
  win:setFrame(screenDimensions)
end

-- Center window
function WinMan.centerWindow()
  local win = hs.window.focusedWindow()
  local screenDimensions = WinMan.getScreenDimensions()
  local windowFrame = win:frame()

  windowFrame.x = screenDimensions.x + (screenDimensions.w * 0.10)
  windowFrame.y = screenDimensions.y + (screenDimensions.h * 0.05)
  windowFrame.w = screenDimensions.w * 0.8
  windowFrame.h = screenDimensions.h * 0.9

  WinMan.undoPush()
  win:setFrame(windowFrame)
end

-- Move window to the next monitor
function WinMan.moveWindowToNextMonitor()
  local win = hs.window.focusedWindow()
  local screenFrame = win:screen():frame()
  local nextScreenFrame = win:screen():next():frame()
  local windowFrame = win:frame()

  windowFrame.x = ((((windowFrame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
  windowFrame.y = ((((windowFrame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
  windowFrame.h = ((windowFrame.h / screenFrame.h) * nextScreenFrame.h)
  windowFrame.w = ((windowFrame.w / screenFrame.w) * nextScreenFrame.w)

  win:setFrame(windowFrame)
end

-- Screen dimensions utility function
function WinMan.getScreenDimensions()
  return hs.window.focusedWindow():screen():frame()
end

function WinMan.undoPush()
  local win = hs.window.focusedWindow()
  if win and not WinMan.undo[win:id()] then
    WinMan.undo[win:id()] = win:frame()
  end
end

function WinMan.undoPop()
  local win = hs.window.focusedWindow()
  if win and WinMan.undo[win:id()] then
    win:setFrame(WinMan.undo[win:id()])
    WinMan.undo[win:id()] = nil
  end
end

return WinMan
