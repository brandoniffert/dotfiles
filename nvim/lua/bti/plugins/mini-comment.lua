---@type LazySpec
return {
  "echasnovski/mini.comment",
  event = "BufReadPre",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  opts = {
    hooks = {
      pre = function()
        require("ts_context_commentstring.internal").update_commentstring({})
      end,
    },
  },
}
