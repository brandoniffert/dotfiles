return {
  -- PLUGIN: hrsh7th/nvim-cmp
  -- PLUGIN: hrsh7th/cmp-buffer
  -- PLUGIN: hrsh7th/cmp-path
  -- PLUGIN: onsails/lspkind-nvim
  -- PLUGIN: andersevenrud/cmp-tmux
  -- PLUGIN: saadparwaiz1/cmp_luasnip
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
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
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-u>"] = cmp.mapping.scroll_docs(4),
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
        sources = {
          {
            name = "nvim_lsp",
          },
          {
            name = "luasnip",
          },
          {
            name = "buffer",
            option = {
              keyword_length = 2,
              max_item_count = 10,
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
          {
            name = "tmux",
            option = {
              trigger_characters = {},
            },
          },
          {
            name = "path",
          },
        },
        sorting = {
          comparators = {
            function(...)
              return cmp_buffer:compare_locality(...)
            end,
          },
        },
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
        -- prevent back to snippet when leaving it
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })

      require("luasnip.loaders.from_lua").load()

      -- vim.keymap.set({ 'i', 's' }, '<c-k>', function()
      --   if ls.expand_or_jumpable() then
      --     ls.expand_or_jump()
      --   end
      -- end, { silent = true })
      --
      -- vim.keymap.set({ 'i', 's' }, '<c-j>', function()
      --   if ls.jumpable(-1) then
      --     ls.jump(-1)
      --   end
      -- end, { silent = true })
    end,
  },
}
