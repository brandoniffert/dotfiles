---@type LazySpec
return {
  "numToStr/Navigator.nvim",
  lazy = false,
  keys = {
    { "<C-h>", "<cmd>NavigatorLeft<CR>", mode = { "n", "t" }, desc = "Navigate left" },
    { "<C-j>", "<cmd>NavigatorDown<CR>", mode = { "n", "t" }, desc = "Navigate down" },
    { "<C-k>", "<cmd>NavigatorUp<CR>", mode = { "n", "t" }, desc = "Navigate up" },
    { "<C-l>", "<cmd>NavigatorRight<CR>", mode = { "n", "t" }, desc = "Navigate right" },
  },
  config = function()
    require("Navigator").setup({
      auto_save = nil,
      disable_on_zoom = false,
      mux = "auto",
    })

    -- Snacks Explorer is technically a floating window which messes with the edge logic of Navigator in tmux
    -- If focused inside a Snacks Explorer picker, we should always move to the left pane in tmux
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "snacks_picker_list" },
      callback = function()
        vim.keymap.set("n", "<C-h>", function()
          if vim.env.TMUX then
            vim.fn.system("tmux select-pane -L")
          else
            vim.cmd("NavigatorLeft")
          end
        end, { buffer = true })
      end,
    })
  end,
}
