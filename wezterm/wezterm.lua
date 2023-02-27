local wezterm = require("wezterm")

local function isViProcess(pane)
  return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if isViProcess(pane) then
    window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
  else
    window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
  conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
  conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
  conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
  conditionalActivatePane(window, pane, "Down", "j")
end)

return {
  color_scheme = "Catppuccin Mocha",
  initial_cols = 160,
  initial_rows = 60,
  font = wezterm.font_with_fallback({
    { family = "Operator Mono SSm", weight = "Light" },
    "Symbols Nerd Font",
  }),
  font_rules = {
    {
      intensity = "Normal",
      italic = true,
      font = wezterm.font({
        family = "Operator Mono SSm",
        weight = "Light",
      }),
    },
    {
      intensity = "Bold",
      font = wezterm.font({
        family = "Operator Mono SSm",
        weight = "Book",
      }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font({
        family = "Operator Mono SSm",
        weight = "Book",
        italic = true,
      }),
    },
  },
  font_size = 10.5,
  line_height = 1.4,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  hide_tab_bar_if_only_one_tab = true,
  window_padding = {
    left = "3cell",
    right = "3cell",
    top = "1cell",
    bottom = "1cell",
  },
  window_decorations = "RESIZE",
  colors = {
    tab_bar = {
      background = "#1e1e2e",
      active_tab = {
        bg_color = "#2c2c44",
        fg_color = "white",
      },
      inactive_tab = {
        bg_color = "#1e1e2e",
        fg_color = "white",
      },
      new_tab = {
        bg_color = "#1e1e2e",
        fg_color = "#1e1e2e",
      },
    },
  },
  leader = { key = "Space", mods = "CTRL" },
  keys = {
    { key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    { key = "=", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
    { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "Space", mods = "LEADER|CTRL", action = wezterm.action.ActivateLastTab },
    { key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
    { key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
    { key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
    { key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
    { key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
    { key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
    { key = "h", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
    { key = "j", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
    { key = "k", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
    { key = "l", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
    { key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },
  },
}
