return {
  "nvim-telescope/telescope.nvim",
  requires = {
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    { "nvim-telescope/telescope-rg.nvim" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "❯ ",
        mappings = {
          i = {
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<Esc>"] = actions.close,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("neoclip")
  end,
}
