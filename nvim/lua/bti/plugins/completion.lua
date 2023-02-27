return {
  -- PLUGIN: hrsh7th/nvim-cmp
  -- PLUGIN: hrsh7th/cmp-buffer
  -- PLUGIN: hrsh7th/cmp-cmdline
  -- PLUGIN: hrsh7th/cmp-path
  -- PLUGIN: onsails/lspkind-nvim
  -- PLUGIN: andersevenrud/cmp-tmux
  -- PLUGIN: saadparwaiz1/cmp_luasnip
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "andersevenrud/cmp-tmux",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local cmp = require("cmp")
      local cmp_buffer = require("cmp_buffer")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            with_text = true,
            menu = {
              buffer = "[Buffer]",
              tmux = "[Tmux]",
              luasnip = "[Snippet]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              path = "[Path]",
            },
          }),
        },
        window = {
          completion = {
            border = "single",
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            border = "single",
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            select = false,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
        }, {
          {
            name = "tmux",
            option = {
              trigger_characters = {},
            },
          },
        }),
        sorting = {
          comparators = {
            function(...)
              return cmp_buffer:compare_locality(...)
            end,
          },
        },
      })

      cmp.setup.filetype("norg", {
        sources = cmp.config.sources({
          { name = "neorg" },
          { name = "luasnip" },
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            keyword_length = 2,
          },
        }),
      })
    end,
  },

  -- PLUGIN: L3MON4D3/LuaSnip
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      local ls = require("luasnip")

      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })

      ls.filetype_extend("typescript", { "javascript" })

      require("luasnip.loaders.from_lua").lazy_load({
        paths = "~/.config/nvim/lua/bti/snippets",
      })

      vim.keymap.set({ "i", "s" }, "<C-n>", "<Plug>luasnip-next-choice", {})
      vim.keymap.set({ "i", "s" }, "<C-p>", "<Plug>luasnip-prev-choice", {})
      vim.keymap.set({ "i" }, "<C-u>", "<cmd>lua require('luasnip.extras.select_choice')()<CR>")
    end,
  },
}
