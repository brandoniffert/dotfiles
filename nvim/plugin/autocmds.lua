local augroups = {}

augroups.editor = {
  create_missing_directories = {
    event = { "BufWritePre", "FileWritePre" },
    command = [[silent! call mkdir(expand("<afile>:p:h"), "p")]],
  },

  disable_paste = {
    event = { "InsertLeave" },
    command = "set nopaste",
  },
}

augroups.filetype = {
  quit_with_q = {
    event = { "FileType" },
    pattern = { "checkhealth", "fugitive", "git*", "help", "lspinfo" },
    callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<cr>", { noremap = true, silent = true })
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
      local should_focus = vim.bo.filetype ~= "" or bti.g.did_load

      if should_focus then
        bti.util.focus.focus_window()
      end
    end,
  },

  off = {
    event = { "FocusLost", "WinLeave" },
    callback = function()
      local win_type = vim.fn.win_gettype()

      if win_type ~= "popup" then
        bti.util.focus.blur_window()
      end
    end,
  },
}

augroups.misc = {
  indicate_did_load = {
    event = { "FocusGained" },
    once = true,
    callback = function()
      vim.schedule(function()
        bti.g.did_load = true
      end)
    end,
  },
}

augroups.reload = {
  packer = {
    event = { "BufWritePost" },
    pattern = {
      "*/bti/plugins.lua",
      "*/bti/config/*.lua",
    },
    callback = function()
      for name, _ in pairs(package.loaded) do
        if name:match("^bti") then
          package.loaded[name] = nil
        end
      end

      dofile(vim.env.MYVIMRC)
      require("packer").compile()
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
      local test_line_data = vim.api.nvim_buf_get_mark(0, '"')
      local test_line = test_line_data[1]
      local last_line = vim.api.nvim_buf_line_count(0)

      if test_line > 0 and test_line <= last_line then
        vim.api.nvim_win_set_cursor(0, test_line_data)
      end
    end,
  },

  setup_terminal = {
    event = { "TermOpen" },
    command = "setlocal nonumber norelativenumber | startinsert",
  },

  vim_resized = {
    event = { "VimResized" },
    command = 'execute "normal! \\<c-w>="',
  },

  yank = {
    event = { "TextYankPost" },
    command = "if v:event.operator is 'y' && v:event.regname is '*' | execute 'OSCYankReg *' | endif | silent! lua require('vim.highlight').on_yank()",
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
