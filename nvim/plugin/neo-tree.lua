vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  {
    src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
    version = vim.version.range("3"),
  },
})

require("neo-tree").setup({
  filesystem = {
    bind_to_cwd = false,
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        "node_modules",
      },
      never_show = {
        ".DS_Store",
      },
    },
    follow_current_file = {
      enabled = true,
    },
    hijack_netrw_behavior = "disabled",
    use_libuv_file_watcher = true,
  },
  window = {
    mappings = {
      ["<space>"] = "none",
    },
  },
  enable_diagnostics = false,
  default_component_configs = {
    ---@diagnostic disable-next-line: missing-fields
    icon = {
      ---@param icon table
      ---@param node any
      provider = function(icon, node)
        local text, hl
        local mini_icons = require("mini.icons")
        if node.type == "file" then
          text, hl = mini_icons.get("file", node.name)
        elseif node.type == "directory" then
          text, hl = mini_icons.get("directory", node.name)
          if node:is_expanded() then
            text = nil
          end
        end

        if text then
          icon.text = text
        end
        if hl then
          icon.highlight = hl
        end
      end,
    },
    kind_icon = {
      provider = function(icon, node)
        local mini_icons = require("mini.icons")
        icon.text, icon.highlight = mini_icons.get("lsp", node.extra.kind.name)
      end,
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = false,
      highlight = "NeoTreeFileName",
    },
    indent = {
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
  },
})

vim.keymap.set("n", "<Leader>\\", function()
  require("neo-tree.command").execute({ toggle = true })
end, { desc = "Neotree" })
