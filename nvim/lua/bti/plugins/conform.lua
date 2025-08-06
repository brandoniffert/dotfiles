---@type LazySpec
return {
  "stevearc/conform.nvim",
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      astro = { "rustywind", "prettierd" },
      css = { "prettierd" },
      graphql = { "prettierd" },
      html = function(bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)

        if filename:match("%.ss$") then
          return { "rustywind_ss_html" }
        else
          return { "rustywind" }
        end
      end,
      javascript = { "rustywind", "prettierd" },
      javascriptreact = { "rustywind", "prettierd" },
      json = { "prettierd" },
      less = { "prettierd" },
      liquid = { "rustywind", "prettierd" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      php = function()
        local has_php_cs_fixer_config = require("bti.util").has_ancestor_files({
          ".php-cs-fixer.dist.php",
        })

        local has_php_cs_config = require("bti.util").has_ancestor_files({
          "phpcs.xml.dist",
        })

        if has_php_cs_fixer_config then
          return { "php_cs_fixer" }
        end

        if has_php_cs_config then
          return { "phpcbf" }
        end

        return { "php_cs_fixer" }
      end,
      scss = { "prettierd" },
      svelte = { "rustywind" },
      typescript = { "rustywind", "prettierd" },
      typescriptreact = { "rustywind", "prettierd" },
      vue = { "rustywind" },
      yaml = { "prettierd" },
    },
    formatters = {
      rustywind_ss_html = {
        command = "rustywind",
        args = function()
          return {
            "--stdin",
            "--custom-regex",
            -- Regex breakdown:
            -- (?:                                    - Start non-capturing group (alternation)
            --   \b(?:\w*(?:[Cc]lass|[Cc]lasses|[Cc]lass[Nn]ame))\s*=\s*[\"']  - PATTERN 1: Class attributes
            --     \b                                 - Word boundary
            --     (?:\w*(?:[Cc]lass|[Cc]lasses|[Cc]lass[Nn]ame))  - Class attribute names:
            --       \w*                              - Zero or more word chars (prefix like "Extra", "my")
            --       (?:[Cc]lass|[Cc]lasses|[Cc]lass[Nn]ame)  - "class"/"Class"/"classes"/"Classes"/"className"/"ClassName"
            --     \s*=\s*                            - Equals sign with optional whitespace
            --     [\"']                              - Opening quote (single or double)
            --   |                                    - OR alternation
            --   \$\w+\([^)]*'                       - PATTERN 2a: $Function(...'classes')
            --     \$                                 - Literal dollar sign
            --     \w+                                - Function name (one or more word chars)
            --     \(                                 - Opening parenthesis
            --     [^)]*                              - Any chars except closing paren (parameters before quote)
            --     '                                  - Single quote opening the class string
            --   |                                    - OR alternation
            --   \$\w+\([^)]*"                       - PATTERN 2b: $Function(..."classes")
            --     \$                                 - Literal dollar sign
            --     \w+                                - Function name
            --     \(                                 - Opening parenthesis
            --     [^)]*                              - Any chars except closing paren
            --     "                                  - Double quote opening the class string
            -- )                                      - End non-capturing group
            -- ([_a-zA-Z0-9\.,\s\-:\[\]()/#]+)      - CAPTURING GROUP: The actual CSS classes
            --   [_a-zA-Z0-9\.,\s\-:\[\]()/#]+      - Character class for valid CSS class characters:
            --     _                                  - Underscore
            --     a-zA-Z                             - Letters
            --     0-9                                - Numbers
            --     \.                                 - Dot (escaped)
            --     ,                                  - Comma
            --     \s                                 - Whitespace (spaces between classes)
            --     \-                                 - Hyphen (escaped)
            --     :                                  - Colon (for pseudo-classes, modifiers)
            --     \[\]                               - Square brackets (escaped, for array notation)
            --     ()                                 - Parentheses
            --     /#                                 - Forward slash and hash
            --     +                                  - One or more of above chars (classes can't be empty)
            -- [\"']                                 - Closing quote (single or double, matches opening)
            --
            -- MATCHES:
            -- class="px-4 py-2"              ✓ (Pattern 1)
            -- className="text-lg font-bold"  ✓ (Pattern 1)
            -- ExtraClass="bg-red-500"        ✓ (Pattern 1)
            -- $AssetIcon($Icon, 'w-8 h-8')   ✓ (Pattern 2a)
            -- $Image("lg:w-min text-base")   ✓ (Pattern 2b)
            "(?:\\b(?:\\w*(?:[Cc]lass|[Cc]lasses|[Cc]lass[Nn]ame))\\s*=\\s*[\"']|\\$\\w+\\([^)]*'|\\$\\w+\\([^)]*\")([_a-zA-Z0-9\\.,\\s\\-:\\[\\]()/#]+)[\"']",
          }
        end,
      },
    },
    format_on_save = function(bufnr)
      local ignore_filetypes = {}

      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end

      if require("bti.util.format").autoformat then
        return { timeout_ms = 500, lsp_fallback = true }
      end
    end,
  },
}
