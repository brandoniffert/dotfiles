local M = {}

M.icons = {
  diagnostics = {
    Error = "■",
    Warn = "■",
    Hint = "■",
    Info = "■",
  },
}

-- Using catppuccin mocha colors
-- https://github.com/catppuccin/catppuccin
M.colors = {
  none = "NONE",
  crust = "#11111B",
  mantle = "#181825",
  base = "#1E1E2E",
  base1 = "#242438", -- Custom
  surface0 = "#313244",
  surface1 = "#45475A",
  surface2 = "#585B70",
  overlay0 = "#6C7086",
  overlay1 = "#7F849C",
  overlay2 = "#9399B2",
  subtext0 = "#A6ADC8",
  subtext1 = "#BAC2DE",
  text = "#CDD6F4",
  lavender = "#B4BEFE",
  blue = "#89B4FA",
  sapphire = "#74C7EC",
  sky = "#89DCEB",
  teal = "#94E2D5",
  green = "#A6E3A1",
  yellow = "#F9E2AF",
  peach = "#FAB387",
  maroon = "#EBA0AC",
  red = "#F38BA8",
  mauve = "#CBA6F7",
  pink = "#F5C2E7",
  flamingo = "#F2CDCD",
  rosewater = "#F5E0DC",
}

return M
