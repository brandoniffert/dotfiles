return {
  "ojroques/nvim-osc52",
  keys = {
    {
      "<Leader>y",
      function()
        require("osc52").copy_visual()
      end,
      mode = { "v" },
      desc = "Yank to system clipboard",
    },
  },
  config = true,
}
