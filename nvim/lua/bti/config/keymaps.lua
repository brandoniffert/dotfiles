local has_plugin = require("bti.util").has_plugin

local k = vim.keymap.set

-- Navigate over wrapped lines
k("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
k("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Use hjkl for switching between splits
if has_plugin("nvim-tmux-navigation") then
  k("n", "<C-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft, { desc = "Go to left window" })
  k("n", "<C-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown, { desc = "Go to lower window" })
  k("n", "<C-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp, { desc = "Go to upper window" })
  k("n", "<C-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight, { desc = "Go to right window" })
end

-- Use arrow keys for tab navigation
k("n", "<Left>", ":tabp<CR>")
k("n", "<Right>", ":tabn<CR>")

-- Easy indent/outdent
k("n", "<Tab>", ">>")
k("n", "<S-Tab>", "<<")
k("v", "<Tab>", ">gv")
k("v", "<S-Tab>", "<gv")

-- Add undo break-points
k("i", ",", ",<c-g>u")
k("i", ".", ".<c-g>u")
k("i", ";", ";<c-g>u")

-- Split lines (opposite of J)
k("n", "|", ":<c-u>call bti#functions#break_here()<CR>")

-- Don't replace register with text that was pasted over
k("x", "p", "p:if v:register == '\"'<bar>let @@=@0<bar>endif<CR>")

-- Quickfix navigation
k("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
k("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
k("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
k("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
k("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
k("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
k("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
k("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Normal (Leader)
k(
  "n",
  "<Leader><Leader>",
  ":<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>",
  { desc = "Last file" }
)

k("n", "<Leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers but the current one" })

k("n", "<Leader>e", ':edit <C-R>=expand("%:p:h") . "/"<CR>', { silent = false, desc = "Edit File (Same Directory)" })

k("n", "<Leader>p", '"*p', { desc = "Paste from clipboard" })
k("n", "<Leader>q", "<cmd>:q<CR>", { desc = "Quit" })
k("n", "<Leader>Q", "<cmd>:q!<CR>", { desc = "Quit without saving" })

k("n", "<Leader>uf", ":call bti#functions#replace_fancy_characters()<CR>", { desc = "Replace fancy characters" })
k("n", "<Leader>ul", "<cmd>:Lazy<CR>", { desc = "Lazy" })
k("n", "<Leader>ur", ":make!<CR>", { desc = "Run current file" })
k("n", "<Leader>uv", "V`]", { desc = "Select text that was just pasted" })
k("n", "<Leader>uw", ":call bti#functions#strip_whitespace()<CR>", { desc = "Strip whitespace" })

k("n", "<Leader>=", ":vnew<CR>", { desc = "Vertical split" })
k("n", "<Leader>-", ":new<CR>", { desc = "Horizontal split" })

-- Visual (Leader)
k("v", "<Leader>y", '"*y', { desc = "Yank to clipboard" })
