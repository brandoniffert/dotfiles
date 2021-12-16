return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")

    local function create_handle(cmd)
      local handle = io.popen(cmd)
      local data = handle:read("*a")
      handle:close()
      return data
    end

    local header = {
      type = "text",
      val = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      },
      opts = {
        position = "center",
        hl = "Type",
      },
    }

    local footer = {
      type = "text",
      val = function()
        return create_handle([[nvim --version | head -1]])
      end,
      opts = {
        position = "center",
        hl = "Comment",
      },
    }

    local function button(sc, txt, keybind, keybind_opts)
      local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

      local opts = {
        position = "center",
        shortcut = sc,
        cursor = 5,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
      }

      if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
      end

      local function on_press()
        local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "normal", false)
      end

      return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
      }
    end

    local buttons = {
      type = "group",
      val = {
        button("f", "  Find file", ":lua require('bti.util.telescope').find_files() <CR>"),
        button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        button("t", "  Find text", ":lua require('telescope').extensions.live_grep_raw.live_grep_raw() <CR>"),
        button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
        button("q", "  Quit Neovim", ":qa<CR>"),
      },
      opts = {
        spacing = 1,
      },
    }

    local section_height = function(tbl)
      local count = 0

      for _ in pairs(tbl) do
        count = count + 1
      end

      return count
    end

    local top_offset = function()
      return math.floor(vim.fn.winheight("%") / 2) - section_height(header.val) - section_height(buttons.val)
    end

    local opts = {
      layout = {
        { type = "padding", val = top_offset() },
        header,
        { type = "padding", val = 2 },
        buttons,
        footer,
      },
      opts = {
        margin = 5,
      },
    }

    alpha.setup(opts)
  end,
}
