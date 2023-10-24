return {
  "ibhagwan/fzf-lua",
  config = function()
    require("fzf-lua").setup({
      files = {
        git_icons = false,
      },
      oldfiles = {
        cwd_only = true,
        include_current_session = true,
      },
      grep = {
        git_icons = false,
        rg_glob = true,
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --colors=path:fg:147,153,178",
      },
      fzf_opts = {
        ["--border"] = "none",
        ["--height"] = "100%",
        ["--info"] = "inline",
        ["--layout"] = "default",
        ["--no-scrollbar"] = "",
        ["--no-separator"] = "",
      },
      winopts = {
        border = "single",
        width = 0.90,
      },
    })

    vim.keymap.set("n", "<Leader><CR>", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Files" })
    vim.keymap.set("n", "<Leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Files" })
    vim.keymap.set(
      "n",
      "<Leader>fF",
      '<cmd>lua require("fzf-lua").files({ prompt = "Files (All)❯ ", fd_opts = "--color=never --type f --hidden --follow --exclude .git --no-ignore" })<CR>',
      { desc = "Files (All)" }
    )
    vim.keymap.set("n", "<Leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "Grep" })
    vim.keymap.set(
      "n",
      "<Leader>fG",
      '<cmd>lua require("fzf-lua").live_grep({ prompt = "Grep (All)❯ ", rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --no-ignore" })<CR>',
      { desc = "Grep (All)" }
    )
    vim.keymap.set("n", "<Leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", { desc = "Buffers" })
    vim.keymap.set("n", "<Leader>fo", "<cmd>lua require('fzf-lua').oldfiles()<CR>", { desc = "Oldfiles" })
    vim.keymap.set("n", "<Leader>fc", "<cmd>lua require('fzf-lua').commands()<CR>", { desc = "Commands" })
    vim.keymap.set("n", "<Leader>f:", "<cmd>lua require('fzf-lua').command_history()<CR>", { desc = "Command History" })
    vim.keymap.set("n", "<Leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "Help" })
    vim.keymap.set("n", "<Leader>fy", "<cmd>lua require('neoclip.fzf')()<CR>", { desc = "Clipboard" })
  end,
}
