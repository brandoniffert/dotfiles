local float = require("float")

-- Copy-mode stand-in: focused pane's scrollback in nvim, in a floating layer
rex.action({
  name = "scrollback",
  title = "Edit Scrollback",
  run = function(ctx)
    float.open({
      label = "scrollback",
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      options = {
        command = {
          "sh",
          "-c",
          'printf "\\033]0;scrollback\\007"; f=$(mktemp "${TMPDIR:-/tmp}/rex-scrollback.XXXXXX") || exit; trap \'rm -f "$f"\' EXIT; rex capture -b "$1" --trim --unwrap > "$f" && nvim -R + "$f"',
          "sh",
          ctx.block_id,
        },
        cwd = float.cwd(ctx),
      },
    })
  end,
})
