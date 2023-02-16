local has_plugin = require("bti.util").has_plugin
local keymap = require("bti.util").keymap

-- Navigate over wrapped lines
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Use hjkl for switching between splits
if has_plugin("nvim-tmux-navigation") then
  keymap("n", "<C-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft, { desc = "Go to left window" })
  keymap("n", "<C-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown, { desc = "Go to lower window" })
  keymap("n", "<C-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp, { desc = "Go to upper window" })
  keymap("n", "<C-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight, { desc = "Go to right window" })
end

-- Use arrow keys for tab navigation
keymap("n", "<Left>", ":tabp<CR>")
keymap("n", "<Right>", ":tabn<CR>")

-- Easy indent/outdent
keymap("n", "<Tab>", ">>")
keymap("n", "<S-Tab>", "<<")
keymap("v", "<Tab>", ">gv")
keymap("v", "<S-Tab>", "<gv")

-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Split lines (opposite of J)
keymap("n", "|", ":<c-u>call bti#functions#break_here()<CR>")

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

keymap("n", "<Leader>bo", "<cmd>%bd|e#|bd#<CR>", { silent = true, desc = "Close all buffers but the current one" })

keymap("n", "<Leader>e", ':edit <C-R>=expand("%:p:h") . "/"<CR>', { desc = "Edit File (Same Directory)" })

keymap("n", "<Leader>p", '"*p', { desc = "Paste from clipboard" })
keymap("n", "<Leader>q", "<cmd>:q<CR>", { desc = "Quit" })
keymap("n", "<Leader>Q", "<cmd>:q!<CR>", { desc = "Quit without saving" })

keymap("n", "<Leader>uf", ":call bti#functions#replace_fancy_characters()<CR>", { desc = "Replace fancy characters" })
keymap("n", "<Leader>ul", "<cmd>:Lazy<CR>", { desc = "Lazy" })
keymap("n", "<Leader>ur", ":make!<CR>", { desc = "Run current file" })
keymap("n", "<Leader>uv", "V`]", { desc = "Select text that was just pasted" })
keymap("n", "<Leader>uw", ":call bti#functions#strip_whitespace()<CR>", { desc = "Strip whitespace" })

keymap("n", "<Leader>=", ":vnew<CR>", { desc = "Vertical split" })
keymap("n", "<Leader>-", ":new<CR>", { desc = "Horizontal split" })

-- Visual (Leader)
keymap("v", "<Leader>y", '"*y', { desc = "Yank to clipboard" })
