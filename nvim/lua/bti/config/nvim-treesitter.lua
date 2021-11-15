require'nvim-treesitter.configs'.setup({
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = { 'bash' }
  },
  indent = {
    enable = true,
    disable = { 'yaml' }
  }
})
