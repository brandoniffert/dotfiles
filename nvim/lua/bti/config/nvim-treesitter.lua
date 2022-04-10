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
      ensure_installed = "all",
      ignore_install = { "phpdoc" },
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
