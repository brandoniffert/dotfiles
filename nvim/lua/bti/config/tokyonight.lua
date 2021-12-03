vim.g.tokyonight_style = 'night'
vim.g.tokyonight_lualine_bold = true
vim.g.tokyonight_dark_sidebar = true
vim.g.tokyonight_dark_float = true
vim.g.tokyonight_colors = {
  bg_visual = 'bg_highlight'
}

require('tokyonight').colorscheme()

vim.cmd [[hi InactiveWindow guifg=#565f89 guibg=#171821]]
