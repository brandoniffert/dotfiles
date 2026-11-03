local function is_vim(ctx)
  local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  local fg = proc and proc.foreground
  if not fg then
    return false
  end
  -- `name` isn't always the executable, so check argv0 too
  for _, s in ipairs({ fg.name or "", (fg.argv0 or ""):match("[^/]*$") }) do
    if s:match("^n?vim") then
      return true
    end
  end
  return false
end

local M = {}

-- Returns a binding function; false passes the key through to vim
function M.navigate(direction)
  return function(ctx)
    if is_vim(ctx) then
      return false
    end
    rex.session.focus_direction({ direction = direction })
    return true
  end
end

-- Ctrl-l is taken by navigation, so clearing needs its own action
rex.action({
  name = "clear_screen",
  title = "Clear Screen",
  run = function(ctx)
    -- write raw ^L; pane.send_key re-enters bindings and hits the ctrl+l nav
    rex.block.call("com.superlogical.terminal", "write", { block_id = ctx.block_id, data = "\12" })
  end,
})

return M
