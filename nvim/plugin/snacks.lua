vim.pack.add({ { src = "https://github.com/folke/snacks.nvim" } })

require("snacks").setup({
  input = {},
  explorer = {},
  picker = {
    layout = {
      preset = "ivy_split",
    },
    layouts = {
      select = {
        layout = {
          width = 0.3,
          min_width = 80,
        },
      },
    },
    matcher = {
      frecency = true,
    },
    hidden = true,
    formatters = {
      file = {
        truncate = 90,
      },
    },
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
      relative = "editor",
      keys = {
        i_esc = { "<esc>", { "cancel", "stopinsert" }, mode = "i", expr = true },
      },
    },
  },
})

vim.keymap.set("n", "<Leader>\\", function()
  Snacks.explorer()
end, { desc = "File Explorer" })

vim.keymap.set("n", "<Leader><CR>", function()
  Snacks.picker.smart({
    multi = { "buffers", "files" },
  })
end, { desc = "Smart Find Files" })

vim.keymap.set("n", "<Leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<Leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<Leader>fo", function()
  Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Recent" })

vim.keymap.set("n", "<Leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help" })

vim.keymap.set("n", "<Leader>fr", function()
  Snacks.picker.resume()
end, { desc = "Resume" })

vim.keymap.set("n", "<Leader>fc", function()
  Snacks.picker.commands({ layout = { preset = "select" } })
end, { desc = "Commands" })

vim.keymap.set("n", "<Leader>fp", function()
  Snacks.picker.pickers()
end, { desc = "Pickers" })

vim.keymap.set("n", "<Leader>fd", function()
  Snacks.picker.pick({
    title = "Directories",
    format = "text",
    layout = { preset = "select" },
    finder = function(opts, ctx)
      local proc_opts = {
        cmd = "fd",
        args = { ".", "--type", "directory" },
      }
      local merged_opts = vim.tbl_deep_extend("force", opts or {}, proc_opts)
      return require("snacks.picker.source.proc").proc(merged_opts, ctx)
    end,
    confirm = function(picker, item)
      picker:close()

      if item then
        local selected_dir = item.text

        require("oil").open_float(selected_dir)
      end
    end,
  })
end, { desc = "Directories" })
