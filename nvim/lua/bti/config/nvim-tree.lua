local nnoremap = bti.vim.nnoremap

require'nvim-tree'.setup {
  view = {
    width = 35,
  }
}

nnoremap('<Leader>\\', ':NvimTreeToggle<CR>', { silent = true })
