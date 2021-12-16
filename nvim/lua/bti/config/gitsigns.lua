return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre" },
  config = function()
    require("gitsigns").setup({
      keymaps = {
        ["n <LocalLeader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ["v <LocalLeader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        ["n <LocalLeader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ["n <LocalLeader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ["v <LocalLeader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        ["n <LocalLeader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ["n <LocalLeader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ["n <LocalLeader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
      },
    })
  end,
}
