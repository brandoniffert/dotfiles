---@type LazySpec
return {
  "saghen/blink.cmp",
  dependencies = {
    "mgalliou/blink-cmp-tmux",
  },
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { "lazydev", "lsp", "buffer", "snippets", "path", "tmux" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        tmux = {
          module = "blink-cmp-tmux",
          name = "tmux",
          opts = {
            panes = "window",
            capture_history = false,
            triggered_only = false,
            trigger_chars = { "." },
          },
        },
      },
    },

    keymap = {
      preset = "none",

      ["<C-e>"] = { "show", "hide", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
      },
      ghost_text = { enabled = true },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
    },

    signature = {
      enabled = true,
    },
  },
}
