---@type LazySpec
return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = {
    { "<Leader>o", "<cmd>lua require('oil').open_float()<CR>", desc = "Oil (Float)" },
  },
  config = function()
    local detail = false

    require("oil").setup({
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
        ["q"] = "actions.close",
        ["R"] = "actions.refresh",
      },
      use_default_keymaps = false,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          local hidden_filenames = {
            [".DS_Store"] = true,
          }

          return hidden_filenames[name] == true
        end,
      },
      win_options = {
        number = false,
        relativenumber = false,
      },
      float = {
        max_width = 80,
        max_height = 40,
      },
    })
  end,
}
