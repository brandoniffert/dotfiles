---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    input = {},
    explorer = {},
    picker = {
      layout = "bottom",
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
      sources = {
        explorer = {
          hidden = true,
          exclude = { ".DS_Store" },
          win = {
            input = {
              keys = {
                ["<Esc>"] = "cancel",
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<Leader>\\",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
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
