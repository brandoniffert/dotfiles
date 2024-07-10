local keymap = require("bti.util").keymap

-- Navigate over wrapped lines
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Use arrow keys for tab navigation
keymap("n", "<Left>", ":tabp<CR>")
keymap("n", "<Right>", ":tabn<CR>")

-- Easy indent/outdent
keymap("n", "<Tab>", ">>")
keymap("n", "<S-Tab>", "<<")
keymap("v", "<Tab>", ">gv")
keymap("v", "<S-Tab>", "<gv")

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Split lines (opposite of J)
keymap("n", "|", "<cmd>lua require('bti.util.functions').split_at()<CR>")

-- Don't replace register with text that was pasted over
keymap("x", "p", "p:if v:register == '\"'<bar>let @@=@0<bar>endif<CR>")

-- Quickfix navigation
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
keymap("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Normal (Leader)
keymap(
  "n",
  "<Leader><Leader>",
  ":<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>",
  { desc = "Last file" }
)

keymap("n", "<Leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers but the current one" })

keymap(
  "n",
  "<Leader>e",
  ':edit <C-R>=expand("%:p:h") . "/"<CR>',
  { silent = false, desc = "Edit File (Same Directory)" }
)

keymap("n", "<Leader>p", '"*p', { desc = "Paste from clipboard" })
keymap("n", "<Leader>q", "<cmd>:q<CR>", { desc = "Quit" })
keymap("n", "<Leader>Q", "<cmd>:q!<CR>", { desc = "Quit without saving" })

keymap(
  "n",
  "<Leader>uf",
  "<cmd>lua require('bti.util.functions').replace_fancy_characters()<CR>",
  { desc = "Replace fancy characters" }
)
keymap("n", "<Leader>ul", "<cmd>:Lazy<CR>", { desc = "Lazy" })
keymap("n", "<Leader>ur", ":make!<CR>", { desc = "Run current file" })
keymap("n", "<Leader>uv", "V`]", { desc = "Select text that was just pasted" })
keymap(
  "n",
  "<Leader>uw",
  "<cmd>lua require('bti.util.functions').strip_whitespace()<CR>",
  { desc = "Strip whitespace" }
)

keymap("n", "<Leader>=", ":vnew<CR>", { desc = "Vertical split" })
keymap("n", "<Leader>-", ":new<CR>", { desc = "Horizontal split" })

-- Visual (Leader)
keymap("v", "<Leader>y", '"*y', { desc = "Yank to clipboard" })
