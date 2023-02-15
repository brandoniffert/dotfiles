return {
  -- PLUGIN: nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
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
          "help",
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
          "vue",
          "yaml",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = { "yaml" },
        },
      })
    end,
  },

  -- PLUGIN: nvim-treesitter/playground
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
}
