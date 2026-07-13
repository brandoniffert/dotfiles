vim.pack.add({ { src = "https://github.com/andymass/vim-matchup" } })

-- Treesitter matching is auto-enabled on Neovim >= 0.11.2 and activates per
-- buffer whenever a `queries/<lang>/matchup.scm` exists on the runtimepath
-- (tree-sitter-silverstripe ships one, symlinked into the site queries dir; and
-- vim-matchup bundles after/queries/html/matchup.scm). So `%` on `<% if %>`
-- jumps via the silverstripe host tree, and `%` on `<div>` via the injected
-- html tree -- no per-filetype config needed. See :h matchup-treesitter.
vim.g.matchup_matchparen_offscreen = { method = "popup" }
