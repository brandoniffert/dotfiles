-- Project session picker in a floating layer
rex.bind("cmd+p", function(ctx)
  local env = { "env", "REX_POPUP=1" }
  -- Session switch inside the popup must target the app that pressed the key
  if ctx.client_id then
    table.insert(env, "REX_CLIENT=" .. ctx.client_id)
  end
  local command = env
  for _, arg in ipairs({ "zsh", "-i", "-c", "rnewp" }) do
    table.insert(command, arg)
  end

  local _, err = rex.session.new_layer({
    bounds = { 0.35, 0.35, 0.3, 0.3 },
    focus = true,
    layout = {
      block = {
        flavor = "com.superlogical.terminal.shell",
        label = "Project Sessions",
        options = { command = command, shell = "none" },
      },
    },
  })
  if err then
    rex.log("error", "rnewp: " .. err)
  end
  return true
end)
