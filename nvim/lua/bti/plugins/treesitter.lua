return {
  -- PLUGIN: nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPre",
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

      if vim.fn.has("macunix") and vim.fn.executable("gcc-12") then
        local compilers = require("nvim-treesitter.install").compilers
        table.insert(compilers, 1, "gcc-12")
        require("nvim-treesitter.install").compilers = compilers
      end
    end,
  },

  -- PLUGIN: nvim-treesitter/playground
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
}
