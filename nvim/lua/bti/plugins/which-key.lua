return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      show_help = false,
      plugins = {
        spelling = true,
      },
      key_labels = {
        ["<leader>"] = "SPC",
      },
      icons = {
        breadcrumb = "•",
        separator = "•",
        group = "+",
      },
    })

    local wk = require("which-key")

    wk.register({
      mode = { "n", "v" },
      ["g"] = { name = "+goto" },
      ["gz"] = { name = "+surround" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<Leader>c"] = { name = "+code" },
      ["<Leader>f"] = { name = "+find" },
      ["<Leader>h"] = { name = "+harpoon" },
      ["<leader>u"] = { name = "+util" },
      ["<leader>x"] = { name = "+trouble" },
    })
  end,
}
