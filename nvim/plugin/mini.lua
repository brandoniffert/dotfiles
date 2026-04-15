vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim" },
})

require("mini.ai").setup()
require("mini.align").setup()
require("mini.bracketed").setup()
require("mini.comment").setup()
require("mini.extra").setup()
require("mini.hipatterns").setup({
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
  },
})
require("mini.icons").setup()
require("mini.indentscope").setup({
  draw = {
    delay = 0,
    animation = require("mini.indentscope").gen_animation.none(),
  },
  symbol = "▎",
})

require("mini.jump2d").setup({
  labels = "tnseriaogmplfuwyqbjdhvkzxc",
  view = {
    dim = true,
  },
  allowed_windows = {
    not_current = false,
  },
  mappings = {
    start_jumping = "s",
  },
  silent = true,
})

require("mini.pick").setup()
vim.keymap.set("n", "<Leader><CR>", function()
  MiniPick.builtin.cli({
    command = { "rg", "--files", "--hidden", "--color=never" },
  }, {
    source = { name = "Files (rg)" },
  })
end, { desc = "Find Files" })

local grep_show_aligned = function(buf_id, items, query, opts)
  local delimiter = "\031"
  items = vim.tbl_map(function(item)
    return item:gsub("%z", delimiter)
  end, items)
  items = MiniAlign.align_strings(items, {
    split_pattern = delimiter,
    justify_side = { "left", "right", "right" },
    merge_delimiter = { "", " ", "", " ", "" },
  })
  items = vim.tbl_map(function(item)
    return item:gsub(delimiter, "\0")
  end, items)
  MiniPick.default_show(buf_id, items, query, opts)
end

vim.keymap.set("n", "<Leader>fg", function()
  MiniPick.builtin.grep_live(nil, {
    source = { show = grep_show_aligned },
    window = {
      config = function()
        return { width = vim.o.columns }
      end,
    },
  })
end, { desc = "Grep" })

vim.keymap.set("n", "<Leader>fb", function()
  MiniPick.builtin.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<Leader>fo", function()
  MiniExtra.pickers.oldfiles({ current_dir = true })
end, { desc = "Oldfiles" })

vim.keymap.set("n", "<Leader>fh", function()
  MiniPick.builtin.help()
end, { desc = "Help" })

vim.keymap.set("n", "<Leader>fr", function()
  MiniPick.builtin.resume()
end, { desc = "Resume" })

vim.keymap.set("n", "<Leader>fd", function()
  MiniPick.builtin.cli({
    command = { "fd", ".", "--type", "directory" },
  }, {
    source = {
      name = "Directories",
      choose = function(item)
        vim.schedule(function()
          require("oil").open_float(item)
        end)
      end,
    },
  })
end, { desc = "Directories" })

require("mini.splitjoin").setup()
require("mini.surround").setup({
  mappings = {
    add = "gza",
    delete = "gzd",
    find = "gzf",
    find_left = "gzF",
    highlight = "gzh",
    replace = "gzr",
    update_n_lines = "gzn",
  },
})
require("mini.trailspace").setup()

vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable indentscope for certain filetypes",
  pattern = {
    "checkhealth",
    "help",
    "fzf",
    "lspinfo",
    "Trouble",
  },
  callback = function(event)
    vim.b[event.buf].miniindentscope_disable = true
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Disable indentscope for certain buftypes",
  callback = function(event)
    if vim.tbl_contains({ "nofile", "prompt", "quickfix", "terminal" }, vim.bo[event.buf].buftype) then
      vim.b[event.buf].miniindentscope_disable = true
    end
  end,
})
