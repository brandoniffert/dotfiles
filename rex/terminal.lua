local float = require("float")

-- Scratch shell in a floating layer, at the focused pane's cwd
rex.action({
  name = "float_terminal",
  title = "Floating Terminal",
  run = function(ctx)
    float.open({
      label = "Terminal",
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      options = { cwd = float.cwd(ctx) },
    })
  end,
})
