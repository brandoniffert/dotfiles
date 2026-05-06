vim.pack.add({ { src = "https://github.com/folke/snacks.nvim" } })

require("snacks").setup({
  input = {},
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

vim.keymap.set("n", "<Leader>upd", function()
  local plugins = vim.tbl_map(function(p)
    return { text = p.spec.name }
  end, vim.pack.get())
  table.sort(plugins, function(a, b)
    return a.text < b.text
  end)

  Snacks.picker.pick({
    title = "Delete Plugin",
    format = "text",
    layout = { preset = "select" },
    items = plugins,
    confirm = function(picker, item)
      picker:close()

      if item then
        vim.schedule(function()
          if vim.fn.confirm("Delete " .. item.text .. "?", "&Yes\n&No") == 1 then
            vim.pack.del({ item.text })
            vim.notify("Deleted " .. item.text)
          end
        end)
      end
    end,
  })
end, { desc = "Delete plugin" })

vim.keymap.set("n", "<Leader>fd", function()
  Snacks.picker.pick({
    title = "Directories",
    format = "file",
    layout = { preset = "select" },
    finder = function(opts, ctx)
      return require("snacks.picker.source.proc").proc(
        ctx:opts({
          cmd = "fd",
          args = { ".", "--type", "directory" },
          transform = function(item)
            item.file = item.text
            item.dir = true
          end,
        }),
        ctx
      )
    end,
    confirm = function(picker, item)
      picker:close()

      if item then
        require("oil").open_float(item.file)
      end
    end,
  })
end, { desc = "Directories" })
