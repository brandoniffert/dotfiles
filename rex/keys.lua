local splits = require("smart-splits")

local prefix = "ctrl+space>"

local function bind(key, action, args)
  rex.bind(prefix .. key, action, args)
end

-- Function bindings, not actions: only functions can fall through to nvim
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, splits.navigate(direction))
end

for key, direction in pairs({ left = "left", right = "right", up = "up", down = "down" }) do
  rex.bind("shift+" .. key, "pane.resize", { direction = direction, amount = 5 })
end

-- raw NUL (ctrl+space); pane.send_key re-enters bindings and restarts the prefix
bind("space", function(ctx)
  rex.block.call("com.superlogical.terminal", "write", { block_id = ctx.block_id, data = "\0" })
  return true
end)
bind("shift+;", "client.palette.toggle")
bind("r", "client.config.reload")

-- Tabs
bind("c", "client.tab.new")
bind(",", "client.tab.rename")
bind("q", "client.tab.close")
bind("shift+,", "client.tab.move.backward")
bind("shift+.", "client.tab.move.forward")

-- Panes
bind("=", "pane.split.right")
bind("-", "pane.split.down")
bind("z", "pane.zoom")
bind("x", "pane.close")
bind("]", "right_pane_third")
bind("backspace", "pane.balance")
bind("o", "client.prompt.previous")
bind("i", "client.prompt.next")
bind("ctrl+l", "clear_screen")

-- Sessions
bind("s", "session.switch")
bind("shift+s", "session.new")
bind("shift+q", "session.close")

-- Popups
bind("p", "project_sessions")
bind("g", "lazygit")
bind("`", "float_terminal")
bind("[", "scrollback")
