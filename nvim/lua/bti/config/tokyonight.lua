vim.g.tokyonight_style = 'night'
vim.g.tokyonight_lualine_bold = true
vim.g.tokyonight_dark_sidebar = false
vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_dark_float = false
vim.g.tokyonight_colors = {
  bg = '#171926',
  bg_float = '#151723',
  border = 'bg_highlight',
  bg_visual = 'bg_highlight',
}

vim.cmd [[colorscheme tokyonight]]

vim.cmd [[hi Tabline guifg=#6c759d guibg=#171926]]
vim.cmd [[hi TablineFill guibg=#171926]]
vim.cmd [[hi TablineSel guifg=#c0caf5 guibg=#171926]]
vim.cmd [[hi InactiveWindow guifg=#565f89 guibg=#131520]]
