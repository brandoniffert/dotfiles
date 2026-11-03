local float = require("float")

-- Project session picker in a floating layer
rex.action({
  name = "project_sessions",
  title = "Project Sessions",
  run = function(ctx)
    local command = { "env", "REX_POPUP=1" }
    -- Session switch inside the popup must target the app that pressed the key
    if ctx.client_id then
      table.insert(command, "REX_CLIENT=" .. ctx.client_id)
    end
    for _, arg in ipairs({ "zsh", "-i", "-c", "rnewp" }) do
      table.insert(command, arg)
    end

    float.open({
      label = "Project Sessions",
      bounds = { 0.35, 0.35, 0.3, 0.3 },
      options = { command = command, shell = "none" },
    })
  end,
})
