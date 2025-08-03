---@type LazySpec
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<Leader>ha",
      function()
        require("harpoon"):list():append()
      end,
      desc = "Harpoon (Append)",
    },
    {
      "<Leader>hc",
      function()
        require("harpoon"):list():clear()
      end,
      desc = "Harpoon (Clear)",
    },
    {
      "<Leader>hh",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
      desc = "Harpoon (Toggle)",
    },
    {
      "<Leader>hn",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon (1)",
    },
    {
      "<Leader>he",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon (2)",
    },
    {
      "<Leader>hi",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon (3)",
    },
    {
      "<Leader>ho",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon (4)",
    },
  },
}
