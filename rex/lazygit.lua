-- Lazygit in a floating layer, at the focused pane's cwd
rex.bind("cmd+g", function(ctx)
  local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  local cwd = proc and proc.foreground and proc.foreground.cwd
  if not cwd then
    return false
  end

  local _, err = rex.session.new_layer({
    bounds = { 0.1, 0.1, 0.8, 0.8 },
    focus = true,
    layout = {
      block = {
        flavor = "com.superlogical.terminal.shell",
        label = "lazygit",
        options = {
          -- Header shows the terminal title, not the block label (open Rex feature request), so set it here
          command = { "sh", "-c", 'printf "\\033]0;%s\\007" "$1"; exec lazygit', "sh", cwd },
          cwd = cwd,
        },
      },
    },
  })
  if err then
    rex.log("error", "lazygit: " .. err)
  end
  return true
end)
