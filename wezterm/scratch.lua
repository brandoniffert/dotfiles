local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

wezterm.on("gui-startup", function(cmd)
  local _, pane, window = mux.spawn_window(cmd or {})
  local gui = window:gui_window()
  gui:perform_action(act.ToggleAlwaysOnTop, pane)

  local screen = wezterm.gui.screens().active
  local dims = gui:get_dimensions()
  local offset = 20
  local x = screen.width - dims.pixel_width - offset
  local y = offset
  gui:set_position(x, y)
end)

return {
  default_cwd = "/Users/brandoniffert/Scratch",
  default_prog = {
    "/opt/homebrew/bin/nvim",
    "/Users/brandoniffert/Scratch/scratch.md",
  },
  font = wezterm.font_with_fallback({
    { family = "JetBrains Mono", weight = 200 },
    { family = "Symbols Nerd Font" },
  }),
  window_padding = {
    left = "3cell",
    right = "3cell",
    top = "1cell",
    bottom = "1cell",
  },
  window_decorations = "RESIZE",
  window_background_opacity = 0.95,
  color_scheme = "Catppuccin Mocha",
  font_size = 10.5,
  line_height = 1.2,
  initial_cols = 100,
  initial_rows = 55,
  exit_behavior = "Close",
  enable_tab_bar = false,
}
