---@type LazySpec
return {
  "stevearc/oil.nvim",
  keys = {
    { "<Leader>o", "<cmd>lua require('oil').open_float()<CR>", desc = "Oil (Float)" },
  },
  opts = {
    default_file_explorer = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-p>"] = "actions.preview",
      ["q"] = "actions.close",
      ["R"] = "actions.refresh",
      ["<BS>"] = "actions.parent",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
    },
    use_default_keymaps = false,
    win_options = {
      number = false,
    },
    float = {
      max_width = 80,
      max_height = 40,
    },
  },
  config = true,
}
