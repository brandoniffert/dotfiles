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
vim.keymap.set("n", "|", require("bti.util.functions").split_at)

-- Don't replace register with text that was pasted over
vim.keymap.set("x", "p", "p:if v:register == '\"'<bar>let @@=@0<bar>endif<CR>")

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
  ':edit <C-R>=fnameescape(expand("%") == "" ? getcwd() . "/" : expand("%:h") . "/")<CR>',
  { desc = "Edit File (Same Directory)" }
)

vim.keymap.set("n", "<Leader>p", '"*p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "<Leader>q", "<cmd>:q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<Leader>Q", "<cmd>:q!<CR>", { desc = "Quit without saving" })

vim.keymap.set(
  "n",
  "<Leader>uF",
  require("bti.util.functions").replace_fancy_characters,
  { desc = "Replace fancy characters" }
)
vim.keymap.set("n", "<Leader>upp", "<cmd>lua vim.pack.update()<CR>", { desc = "Update plugins" })
vim.keymap.set(
  "n",
  "<Leader>ups",
  "<cmd>lua vim.pack.update(nil, { target = 'lockfile' })<CR>",
  { desc = "Sync plugins (lockfile)" }
)
vim.keymap.set("n", "<Leader>ur", ":make!<CR>", { desc = "Run current file" })
vim.keymap.set("n", "<Leader>uv", "V`]", { desc = "Select text that was just pasted" })
vim.keymap.set("n", "<Leader>uw", require("bti.util.functions").strip_whitespace, { desc = "Strip whitespace" })

vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<Leader>uu", require("undotree").open, { desc = "Open undotree" })

vim.keymap.set("n", "<Leader>=", ":vnew<CR>", { silent = true, desc = "Vertical split" })
vim.keymap.set("n", "<Leader>-", ":new<CR>", { silent = true, desc = "Horizontal split" })

vim.keymap.set("n", "<Leader>yp", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Yanked: " .. path)
end, { desc = "Yank current relative path to clipboard" })

-- Visual (Leader)
vim.keymap.set("v", "<Leader>y", '"*y', { desc = "Yank to clipboard" })
