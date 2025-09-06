-- Need to keep this mostly in sync with https://github.com/neovim/nvim-lspconfig/blob/master/lsp/tailwindcss.lua

local filetypes = {
  -- html
  "aspnetcorerazor",
  "astro",
  "astro-markdown",
  "blade",
  "clojure",
  "django-html",
  "htmldjango",
  "edge",
  "eelixir", -- vim ft
  "elixir",
  "ejs",
  "erb",
  "eruby", -- vim ft
  "gohtml",
  "gohtmltmpl",
  "haml",
  "handlebars",
  "hbs",
  "html",
  "htmlangular",
  "html-eex",
  "heex",
  "jade",
  "leaf",
  "liquid",
  "markdown",
  "mdx",
  "mustache",
  "njk",
  "nunjucks",
  "php",
  "razor",
  "slim",
  "twig",
  -- css
  "css",
  "less",
  "postcss",
  "sass",
  "scss",
  "stylus",
  "sugarss",
  -- js
  "javascript",
  "javascriptreact",
  "reason",
  "rescript",
  "typescript",
  "typescriptreact",
  -- mixed
  "vue",
  "svelte",
  "templ",
}

local settings = {
  tailwindCSS = {
    classAttributes = {
      "class",
      "className",
      "class:list",
      "classList",
      "ngClass",
    },
    includeLanguages = {
      eelixir = "html-eex",
      elixir = "phoenix-heex",
      eruby = "erb",
      heex = "phoenix-heex",
      htmlangular = "html",
      templ = "html",
    },
  },
}

-- Custom values
local customFiletypes = {
  "silverstripe",
}

local customClassAttributes = {
  "Class",
  "Classes",
  "ExtraClass",
  "ExtraClasses",
}

local customIncludeLanguages = {
  silverstripe = "html",
}

-- Append custom values
for _, ft in ipairs(customFiletypes) do
  table.insert(filetypes, ft)
end

for _, attr in ipairs(customClassAttributes) do
  table.insert(settings.tailwindCSS.classAttributes, attr)
end

for lang, mapping in pairs(customIncludeLanguages) do
  settings.tailwindCSS.includeLanguages[lang] = mapping
end

---@type vim.lsp.Config
return {
  filetypes = filetypes,
  settings = settings,
}
