---@type LazySpec
return {
  "stevearc/oil.nvim",
  keys = {
    { "<Leader>o", "<cmd>lua require('oil').open_float()<CR>", desc = "Oil (Float)" },
  },
  config = function()
    local detail = false

    require("oil").setup({
      default_file_explorer = false,
      keymaps = {
        ["q"] = "actions.close",
        ["R"] = "actions.refresh",
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
      },
      float = {
        max_width = 80,
        max_height = 40,
      },
    })
  end,
}
