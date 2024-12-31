---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",

      ["<C-e>"] = { "hide", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_forward()
          else
            return cmp.select_next()
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return cmp.select_prev()
          end
        end,
        "fallback",
      },

      cmdline = {
        ["<Tab>"] = { "show", "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "single" },
      },
      ghost_text = { enabled = true },
      menu = { border = "single" },
      list = {
        selection = "auto_insert",
      },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },

    signature = {
      enabled = true,
      window = {
        border = "single",
      },
    },

    snippets = {
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    },

    sources = {
      default = { "lsp", "path", "luasnip", "buffer" },
      min_keyword_length = function(ctx)
        return ctx.trigger.kind == "manual" and 0 or 2
      end,
    },
  },
}
