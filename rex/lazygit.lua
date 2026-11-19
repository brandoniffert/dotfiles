local float = require("float")

-- Lazygit in a floating layer, at the focused pane's cwd
rex.action({
  name = "lazygit",
  title = "Lazygit",
  run = function(ctx)
    local cwd = float.cwd(ctx)
    if not cwd then
      rex.log("warn", "lazygit: no cwd for focused pane")
      return
    end

    float.open({
      label = "lazygit",
      options = { command = { "lazygit" }, cwd = cwd },
    })
  end,
})
