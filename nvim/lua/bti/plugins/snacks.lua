---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    input = {},
    picker = {
      layout = "bottom",
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
  },
  keys = {
    {
      "<Leader><CR>",
      function()
        Snacks.picker.smart({
          multi = { "buffers", "files" },
        })
      end,
      desc = "Smart Find Files",
    },
    {
      "<Leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<Leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<Leader>fo",
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent",
    },
    {
      "<Leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help",
    },
    {
      "<Leader>fr",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<Leader>fp",
      function()
        Snacks.picker.pickers()
      end,
      desc = "Pickers",
    },
  },
}
