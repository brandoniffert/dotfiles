return {
  -- PLUGIN: AckslD/nvim-neoclip.lua
  {
    "AckslD/nvim-neoclip.lua",
    config = true,
  },

  -- PLUGIN: folke/which-key.nvim
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        show_help = false,
        plugins = {
          spelling = true,
        },
        key_labels = {
          ["<leader>"] = "SPC",
        },
      })

      local wk = require("which-key")
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<Leader>c"] = { name = "+code" },
        ["<Leader>f"] = { name = "+find" },
        ["<Leader>h"] = { name = "+harpoon" },
        ["<leader>u"] = { name = "+util" },
        ["<leader>x"] = { name = "+trouble" },
      })
    end,
  },

  -- PLUGIN: ggandor/leap.nvim
  -- PLUGIN: ggandor/flit.nvim
  {
    "ggandor/leap.nvim",
    dependencies = {
      {
        "ggandor/flit.nvim",
        opts = {
          labeled_modes = "nv",
        },
      },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  -- PLUGIN: ibhagwan/fzf-lua
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        files = {
          prompt = "Files❯ ",
          git_icons = false,
        },
        grep = {
          git_icons = false,
          rg_glob = true,
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --colors=path:fg:white",
        },
        fzf_opts = {
          ["--border"] = "none",
          ["--height"] = "100%",
          ["--info"] = "inline",
          ["--layout"] = "default",
          ["--no-scrollbar"] = "",
          ["--no-separator"] = "",
          ["--marker"] = " ",
          ["--pointer"] = " ",
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
      vim.keymap.set(
        "n",
        "<Leader>f:",
        "<cmd>lua require('fzf-lua').command_history()<CR>",
        { desc = "Command History" }
      )
      vim.keymap.set("n", "<Leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "Help" })
      vim.keymap.set("n", "<Leader>fy", "<cmd>lua require('neoclip.fzf')()<CR>", { desc = "Clipboard" })
      vim.keymap.set(
        "n",
        "<Leader>fp",
        "<cmd>lua require('bti.util.fzf').plugin_spec_finder()<CR>",
        { desc = "Plugins" }
      )
    end,
  },

  -- PLUGIN: lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },

  -- PLUGIN: numToStr/Navigator.nvim
  {
    "numToStr/Navigator.nvim",
    keys = {
      { "<C-h>", "<cmd>NavigatorLeft<CR>", mode = { "n", "t" }, desc = "Navigate left" },
      { "<C-j>", "<cmd>NavigatorDown<CR>", mode = { "n", "t" }, desc = "Navigate down" },
      { "<C-k>", "<cmd>NavigatorUp<CR>", mode = { "n", "t" }, desc = "Navigate up" },
      { "<C-l>", "<cmd>NavigatorRight<CR>", mode = { "n", "t" }, desc = "Navigate right" },
    },
    config = true,
  },

  -- PLUGIN: nvim-neo-tree/neo-tree.nvim
  -- PLUGIN: MunifTanjim/nui.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "<Leader>\\",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },

  -- PLUGIN: ojroques/vim-oscyank
  {
    "ojroques/vim-oscyank",
    cmd = { "OSCYankReg" },
    init = function()
      vim.g.oscyank_term = "default"
    end,
  },

  -- PLUGIN: smjonas/inc-rename.nvim
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  -- PLUGIN: ThePrimeagen/harpoon
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<Leader>a", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Harpoon (Add Mark)" },
      { "<Leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon" },
      { "<Leader>hn", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", desc = "Harpoon (1)" },
      { "<Leader>he", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", desc = "Harpoon (2)" },
      { "<Leader>hi", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", desc = "Harpoon (3)" },
      { "<Leader>ho", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", desc = "Harpoon (4)" },
    },
  },

  -- PLUGIN: tpope/vim-eunuch
  {
    "tpope/vim-eunuch",
    event = "CmdlineEnter",
  },

  -- PLUGIN: tpope/vim-fugitive
  {
    "tpope/vim-fugitive",
    event = { "CmdLineEnter" },
  },

  -- PLUGIN: tpope/vim-repeat
  {
    "tpope/vim-repeat",
  },

  -- PLUGIN: wincent/loupe
  {
    "wincent/loupe",
    init = function()
      vim.g.LoupeCenterResults = 0
      vim.g.LoupeClearHighlightMap = 0
    end,
    config = function()
      vim.keymap.set("n", "<CR>", "<Plug>(LoupeClearHighlight)", { desc = "Clear search highlight" })
    end,
  },
}
