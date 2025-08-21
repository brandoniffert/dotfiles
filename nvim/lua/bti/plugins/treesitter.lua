---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  config = function()
    require("nvim-treesitter").install({
      "astro",
      "bash",
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
      "jsonc",
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
        pcall(function()
          vim.treesitter.start()
        end)
      end,
    })
  end,
}
