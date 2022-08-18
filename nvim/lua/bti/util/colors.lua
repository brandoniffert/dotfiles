local ok, _ = pcall(require, "catppuccin")

if not ok then
  return
end

local themeColors = require("catppuccin.palettes").get_palette()

local colors = {
  red = themeColors.red,
}

return colors
