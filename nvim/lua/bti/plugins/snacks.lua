---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    input = {},
    explorer = {},
    picker = {
      layout = "vertical",
      hidden = true,
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
      sources = {
        explorer = {
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
    styles = {
      input = {
        keys = {
          i_esc = { "<esc>", { "cancel", "stopinsert" }, mode = "i", expr = true },
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
      "<Leader>fc",
      function()
        Snacks.picker.commands({ layout = { preset = "select" } })
      end,
      desc = "Commands",
    },
    {
      "<Leader>fp",
      function()
        Snacks.picker.pickers()
      end,
      desc = "Pickers",
    },
    {
      "<Leader>fd",
      function()
        Snacks.picker.pick({
          title = "Directories",
          format = "text",
          layout = { preset = "select" },
          finder = function(opts, ctx)
            local proc_opts = {
              cmd = "fd",
              args = { ".", "--type", "directory" },
            }
            return require("snacks.picker.source.proc").proc({ opts, proc_opts }, ctx)
          end,
          confirm = function(picker, item)
            picker:close()

            if item then
              local selected_dir = item.text

              require("oil").open_float(selected_dir)
            end
          end,
        })
      end,
      desc = "Directories",
    },
  },
}
