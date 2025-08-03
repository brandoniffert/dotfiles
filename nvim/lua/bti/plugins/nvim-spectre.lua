---@type LazySpec
return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Spectre",
  opts = {
    open_cmd = "vnew | vertical resize 120",
  },
  config = true,
}
