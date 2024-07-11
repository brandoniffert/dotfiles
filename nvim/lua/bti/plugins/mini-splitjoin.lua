---@type LazySpec
return {
  "echasnovski/mini.splitjoin",
  event = "BufReadPre",
  init = function()
    require("mini.splitjoin").setup()
  end,
}
