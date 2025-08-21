---@type LazySpec
return {
  "echasnovski/mini.nvim",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Disable indentscope for certain filetypes",
      pattern = {
        "checkhealth",
        "help",
        "fzf",
        "lspinfo",
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
        if vim.tbl_contains({ "nofile", "prompt", "quickfix", "terminal" }, vim.bo[event.buf].buftype) then
          vim.b[event.buf].miniindentscope_disable = true
        end
      end,
    })
  end,
  config = function()
    require("mini.ai").setup()
    require("mini.bracketed").setup()
    require("mini.comment").setup()
    require("mini.hipatterns").setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      },
    })
    require("mini.icons").setup()
    require("mini.indentscope").setup({
      draw = {
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      },
      symbol = "▎",
    })
    require("mini.splitjoin").setup()
    require("mini.surround").setup({
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
        update_n_lines = "gzn",
      },
    })
    require("mini.trailspace").setup()
  end,
}
