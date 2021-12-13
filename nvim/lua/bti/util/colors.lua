local ok, theme = pcall(require, "tokyonight.colors")

if not ok then
  return false
end

local themeColors = theme.setup()

local colors = {
  white = themeColors.fg_dark,
  red = themeColors.red,
  magenta = themeColors.magenta,
}

return colors
