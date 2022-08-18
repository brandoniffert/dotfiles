return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      show_help = false,
      plugins = {
        spelling = true,
      },
      key_labels = {
        ["<leader>"] = "SPC",
      },
      window = {
        winblend = 20,
      },
    })
  end,
}
