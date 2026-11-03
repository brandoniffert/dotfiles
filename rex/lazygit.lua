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
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      options = {
        -- Header shows the terminal title, not the block label (open Rex feature request), so set it here
        command = { "sh", "-c", 'printf "\\033]0;%s\\007" "$1"; exec lazygit', "sh", cwd },
        cwd = cwd,
      },
    })
  end,
})
