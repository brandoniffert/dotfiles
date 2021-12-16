return {
  "kyazdani42/nvim-tree.lua",
  cmd = "NvimTreeToggle",
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 35,
      },
    })
  end,
}
