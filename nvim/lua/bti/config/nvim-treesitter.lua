return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  requires = {
    {
      "nvim-treesitter/playground",
      cmd = "TSHighlightCapturesUnderCursor",
    },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = "maintained",
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
    })
  end,
}
