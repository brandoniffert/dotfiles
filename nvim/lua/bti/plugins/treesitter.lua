return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPre",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    {
      "nvim-treesitter/playground",
      cmd = "TSPlaygroundToggle",
    },
  },
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
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
      matchup = {
        enable = true,
        disable_virtual_text = true,
      },
    })

    if vim.fn.has("macunix") and vim.fn.executable("gcc-12") then
      local compilers = require("nvim-treesitter.install").compilers
      table.insert(compilers, 1, "gcc-12")
      require("nvim-treesitter.install").compilers = compilers
    end
  end,
}
