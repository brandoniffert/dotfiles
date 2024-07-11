---@type LazySpec
return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
    })

    ls.filetype_extend("typescript", { "javascript" })

    require("luasnip.loaders.from_lua").lazy_load({
      paths = "~/.config/nvim/lua/bti/snippets",
    })

    vim.keymap.set({ "i", "s" }, "<C-n>", "<Plug>luasnip-next-choice", {})
    vim.keymap.set({ "i", "s" }, "<C-p>", "<Plug>luasnip-prev-choice", {})
    vim.keymap.set({ "i" }, "<C-u>", "<cmd>lua require('luasnip.extras.select_choice')()<CR>")
  end,
}
