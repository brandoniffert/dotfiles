---@type LazySpec
return {
  "ibhagwan/fzf-lua",
  config = function()
    local actions = require("fzf-lua.actions")

    require("fzf-lua").setup({
      "telescope",
      defaults = {
        file_icons = "mini",
      },
      files = {
        git_icons = false,
        actions = { ["ctrl-g"] = false, ["ctrl-i"] = { actions.toggle_ignore } },
      },
      oldfiles = {
        cwd_only = true,
        include_current_session = true,
      },
      grep = {
        git_icons = false,
        rg_glob = true,
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --colors=path:fg:147,153,178",
        actions = { ["ctrl-i"] = { actions.toggle_ignore } },
      },
      fzf_opts = {
        ["--marker"] = "• ",
      },
      winopts = {
        backdrop = 100,
      },
    })

    vim.keymap.set("n", "<Leader><CR>", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Files" })
    vim.keymap.set("n", "<Leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Files" })
    vim.keymap.set("n", "<Leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "Grep" })
    vim.keymap.set("n", "<Leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", { desc = "Buffers" })
    vim.keymap.set("n", "<Leader>fo", "<cmd>lua require('fzf-lua').oldfiles()<CR>", { desc = "Oldfiles" })
    vim.keymap.set("n", "<Leader>fc", "<cmd>lua require('fzf-lua').commands()<CR>", { desc = "Commands" })
    vim.keymap.set("n", "<Leader>f:", "<cmd>lua require('fzf-lua').command_history()<CR>", { desc = "Command History" })
    vim.keymap.set("n", "<Leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "Help" })
    vim.keymap.set("n", "<Leader>fy", "<cmd>lua require('neoclip.fzf')()<CR>", { desc = "Clipboard" })
    vim.keymap.set("n", "<Leader>fr", "<cmd>lua require('fzf-lua').resume()<CR>", { desc = "Resume" })
  end,
}
