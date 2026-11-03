local M = {}

function M.cwd(ctx)
  local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  return proc and proc.foreground and proc.foreground.cwd
end

-- opts: label, bounds, options (terminal block options)
function M.open(opts)
  local _, err = rex.session.new_layer({
    bounds = opts.bounds,
    focus = true,
    layout = {
      block = {
        flavor = "com.superlogical.terminal.shell",
        label = opts.label,
        options = opts.options,
      },
    },
  })
  if err then
    rex.log("error", opts.label .. ": " .. err)
  end
end

return M
