-- Load the generic HTML ftplugin: a .ss file is mostly HTML, so this keeps
-- html's commentstring (`<!-- %s -->` for gc), matchpairs and other editing
-- defaults. Its b:match_words is inert here -- vim-matchup uses the treesitter
-- engine for this buffer (silverstripe matchup.scm exists), so `%` matches
-- `<% if %>`/`<% end_if %>` (host tree) and `<div>`/`</div>` (injected html
-- tree) via tree-sitter, not regex match_words.
vim.cmd("silent! runtime! ftplugin/html.vim")
