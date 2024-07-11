---@type LazySpec
return {
  "ggandor/leap.nvim",
  dependencies = {
    {
      "ggandor/flit.nvim",
      opts = {
        labeled_modes = "nv",
      },
    },
  },
  config = function()
    require("leap").opts.preview_filter = function()
      return false
    end

    vim.keymap.set("n", "s", "<Plug>(leap)")
    vim.keymap.set({ "n", "o" }, "gs", function()
      require("leap.remote").action()
    end)
    vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
    vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")
  end,
}
