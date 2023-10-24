local excluded_buftypes = {
  "nofile",
  "prompt",
  "quickfix",
  "terminal",
}

return {
  "echasnovski/mini.indentscope",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Disable indentscope for certain filetypes",
      pattern = {
        "checkhealth",
        "help",
        "fzf",
        "lspinfo",
        "neo-tree",
        "Trouble",
        "lazy",
      },
      callback = function(event)
        vim.b[event.buf].miniindentscope_disable = true
      end,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
      desc = "Disable indentscope for certain buftypes",
      callback = function(event)
        if vim.tbl_contains(excluded_buftypes, vim.bo[event.buf].buftype) then
          vim.b[event.buf].miniindentscope_disable = true
        end
      end,
    })
  end,
  config = function()
    require("mini.indentscope").setup({
      draw = {
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      },
      symbol = "▎",
    })
  end,
}
