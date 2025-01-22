-- Navigate over wrapped lines
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Use arrow keys for tab navigation
vim.keymap.set("n", "<Left>", "<cmd>tabp<CR>", { silent = true })
vim.keymap.set("n", "<Right>", "<cmd>tabn<CR>", { silent = true })

-- Easy indent/outdent
vim.keymap.set({ "n", "o" }, "<Tab>", ">>_", { silent = true })
vim.keymap.set({ "n", "o" }, "<S-Tab>", "<<_", { silent = true })
vim.keymap.set("v", "<Tab>", ">gv", { silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Split lines (opposite of J)
vim.keymap.set("n", "|", "<cmd>lua require('bti.util.functions').split_at()<CR>")

-- Don't replace register with text that was pasted over
vim.keymap.set("x", "p", "p:if v:register == '\"'<bar>let @@=@0<bar>endif<CR>")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Normal (Leader)
vim.keymap.set(
  "n",
  "<Leader><Leader>",
  ":<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>",
  { silent = true, desc = "Last file" }
)

vim.keymap.set(
  "n",
  "<Leader>bo",
  "<cmd>%bd|e#|bd#<CR>",
  { silent = true, desc = "Close all buffers but the current one" }
)

vim.keymap.set(
  "n",
  "<Leader>e",
  ':edit <C-R>=expand("%") == "" ? getcwd() . "/" : expand("%:h") . "/"<CR>',
  { desc = "Edit File (Same Directory)" }
)

vim.keymap.set("n", "<Leader>p", '"*p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "<Leader>q", "<cmd>:q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<Leader>Q", "<cmd>:q!<CR>", { desc = "Quit without saving" })

vim.keymap.set(
  "n",
  "<Leader>uf",
  "<cmd>lua require('bti.util.functions').replace_fancy_characters()<CR>",
  { desc = "Replace fancy characters" }
)
vim.keymap.set("n", "<Leader>ul", "<cmd>:Lazy<CR>", { desc = "Lazy" })
vim.keymap.set("n", "<Leader>ur", ":make!<CR>", { desc = "Run current file" })
vim.keymap.set("n", "<Leader>uv", "V`]", { desc = "Select text that was just pasted" })
vim.keymap.set(
  "n",
  "<Leader>uw",
  "<cmd>lua require('bti.util.functions').strip_whitespace()<CR>",
  { desc = "Strip whitespace" }
)

vim.keymap.set("n", "<Leader>=", ":vnew<CR>", { silent = true, desc = "Vertical split" })
vim.keymap.set("n", "<Leader>-", ":new<CR>", { silent = true, desc = "Horizontal split" })

-- Visual (Leader)
vim.keymap.set("v", "<Leader>y", '"*y', { desc = "Yank to clipboard" })
