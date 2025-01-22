---@type LazySpec
return {
  "stevearc/dressing.nvim",
  opts = {
    select = {
      backend = "builtin",
      builtin = {
        relative = "cursor",
        min_height = { 0, 0 },
      },
    },
  },
}
