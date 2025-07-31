---@type LazySpec
return {
  {
    "gbprod/yanky.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      highlight = {
        on_put = false,
        on_yank = false,
      },
    },
    keys = {
      {
        "<leader>fy",
        function()
          Snacks.picker.yanky()
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
    },
  },
}
