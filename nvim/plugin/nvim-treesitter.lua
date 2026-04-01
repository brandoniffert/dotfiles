vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    if vim.env.TREE_SITTER_SILVERSTRIPE_DIR then
      ---@diagnostic disable: missing-fields
      require("nvim-treesitter.parsers").silverstripe = {
        install_info = {
          path = vim.env.TREE_SITTER_SILVERSTRIPE_DIR,
          generate = true,
          generate_from_json = true,
          queries = "queries",
        },
      }
    end
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("_bti_TreesitterPackChanged", { clear = true }),
  desc = "Run TSUpdate after nvim-treesitter install/update",
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      vim.cmd("TSUpdate")
    end
  end,
})

require("nvim-treesitter").install({
  "astro",
  "bash",
  "caddy",
  "css",
  "diff",
  "dockerfile",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "graphql",
  "html",
  "htmldjango",
  "javascript",
  "jsdoc",
  "json",
  "liquid",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "php",
  "python",
  "regex",
  "ruby",
  "rust",
  "scss",
  "silverstripe",
  "sql",
  "svelte",
  "terraform",
  "toml",
  "tsx",
  "twig",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("_bti_EnableTreesitterHighlighting", { clear = true }),
  desc = "Try to enable tree-sitter syntax highlighting",
  pattern = "*",
  callback = function()
    local filetype = vim.bo.filetype
    if filetype and filetype ~= "" then
      local success = pcall(function()
        vim.treesitter.start()
      end)
      if not success then
        return
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("_bti_EnableTreesitterIndentation", { clear = true }),
  desc = "Try to enable tree-sitter indentation",
  pattern = { "php", "html", "silverstripe" },
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
