local augroups = {}

augroups.editor = {
  create_missing_directories = {
    event = { "BufWritePre", "FileWritePre" },
    callback = function()
      if vim.tbl_contains({ "oil" }, vim.bo.ft) then
        return
      end

      local dir = vim.fn.expand("<afile>:p:h")

      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end
    end,
  },
}

augroups.filetype = {
  quit_with_q = {
    event = { "FileType" },
    pattern = {
      "checkhealth",
      "fugitive",
      "git*",
      "help",
      "lspinfo",
      "qf",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
  },

  silverstripe = {
    event = { "BufEnter", "BufRead", "BufNewFile" },
    pattern = { "*.ss" },
    command = [[set filetype=html syntax=ss | runtime! indent/ss.vim]],
  },
}

augroups.focus = {
  on = {
    event = { "BufEnter", "FocusGained", "WinEnter" },
    callback = function()
      local should_focus = require("bti.g").did_load

      if should_focus then
        require("bti.util.focus").focus_window()
      end
    end,
  },

  off = {
    event = { "FocusLost", "WinLeave" },
    callback = function()
      local win_type = vim.fn.win_gettype()

      if win_type ~= "popup" then
        require("bti.util.focus").blur_window()
      end
    end,
  },
}

augroups.misc = {
  checktime = {
    event = { "FocusGained", "TermClose", "TermLeave" },
    command = "checktime",
  },

  indicate_did_load = {
    event = { "FocusGained" },
    once = true,
    callback = function()
      vim.schedule(function()
        require("bti.g").did_load = true
      end)
    end,
  },
}

augroups.spell = {
  generate_spell_file = {
    event = { "BufWritePost" },
    pattern = "*/spell/*.add",
    command = "silent! :mkspell! %",
  },
}

augroups.ui = {
  restore_cursor_position = {
    event = { "BufReadPost" },
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  },

  setup_terminal = {
    event = { "TermOpen" },
    command = "setlocal nonumber norelativenumber | startinsert",
  },

  vim_resized = {
    event = { "VimResized" },
    callback = function()
      vim.cmd("tabdo wincmd =")
    end,
  },

  yank = {
    event = { "TextYankPost" },
    command = "lua require('vim.highlight').on_yank()",
  },
}

for group, commands in pairs(augroups) do
  local augroup = vim.api.nvim_create_augroup("_bti_" .. group, { clear = true })

  for _, opts in pairs(commands) do
    local event = opts.event
    opts.event = nil
    opts.group = augroup
    vim.api.nvim_create_autocmd(event, opts)
  end
end
