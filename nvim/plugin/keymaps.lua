local ok, wk = pcall(require, "which-key")

if not ok then
  return
end

-- Clear search highlight
vim.keymap.set("n", "<CR>", "<Plug>(LoupeClearHighlight)")

-- Navigate over wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Use hjkl for switching between splits
vim.keymap.set("n", "<C-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)

-- Use arrow keys for tab navigation
vim.keymap.set("n", "<Left>", ":tabp<CR>")
vim.keymap.set("n", "<Right>", ":tabn<CR>")

-- Easy indent/outdent
vim.keymap.set("n", "<Tab>", ">>")
vim.keymap.set("n", "<S-Tab>", "<<")
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- Split lines (opposite of J)
vim.keymap.set("n", "|", ":<c-u>call bti#functions#break_here()<CR>", { silent = true })

-- Don't replace register with text that was pasted over
vim.keymap.set("x", "p", "p:if v:register == '\"'<bar>let @@=@0<bar>endif<CR>", { silent = true })

-- Normal
wk.register({
  ["]q"] = { "<cmd>cnext<CR>", "Next quickfix item" },
  ["[q"] = { "<cmd>cprevious<CR>", "Previous quickfix item" },
})

-- Normal (Leader)
wk.register({
  ["\\"] = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree" },
  ["<Leader>"] = { ":<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>", "Last file" },
  ["<CR>"] = { "<cmd>lua bti.util.telescope.find_files()<CR>", "Files" },
  e = { ':edit <C-R>=expand("%:p:h") . "/"<CR>', "Edit File (Same Directory)", silent = false },
  f = {
    name = "+find",
    b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
    c = { "<cmd>Telescope commands<CR>", "Commands" },
    f = { "<cmd>lua bti.util.telescope.find_files()<CR>", "Files" },
    F = { "<cmd>lua bti.util.telescope.find_all_files()<CR>", "Files (All)" },
    g = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", "Grep" },
    G = {
      "<cmd>lua require('telescope.builtin').live_grep({ additional_args = function() return { '--hidden', '--no-ignore' } end })<CR>",
      "Grep (All)",
    },
    h = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help" },
    o = { "<cmd>lua require('telescope.builtin').oldfiles()<CR>", "Oldfiles" },
    s = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", "String" },
    S = {
      "<cmd>lua require('telescope.builtin').grep_string({ additional_args = function() return { '--hidden', '--no-ignore' } end })<CR>",
      "String (All)",
    },
    y = { "<cmd>Telescope neoclip<CR>", "Clipboard" },
  },
  p = { '"*p', "Paste from clipboard" },
  q = { "<cmd>:q<CR>", "Quit" },
  Q = { "<cmd>:q!<CR>", "Quit without saving" },
  u = {
    name = "+util",
    c = {
      function()
        vim.cmd([[CatppuccinClean]])
        vim.cmd([[CatppuccinCompile]])
        vim.cmd([[PackerCompile]])
        vim.cmd([[LuaCacheClear]])
      end,
      "Clear caches",
    },
    f = { ":call bti#functions#replace_fancy_characters()<CR>", "Replace fancy characters" },
    h = { "<cmd>TSHighlightCapturesUnderCursor<CR>", "Highlight (Treesitter)" },
    H = { ":echomsg v:lua.bti.functions.get_highlight_group()<CR>", "Highlight (Vim)" },
    p = {
      name = "+packer",
      c = { "<cmd>PackerCompile<CR>", "PackerCompile" },
      s = { "<cmd>PackerSync<CR>", "PackerSync" },
    },
    r = { ":make!<CR>", "Run current file" },
    v = { "V`]", "Select text that was just pasted" },
    w = { ":call bti#functions#strip_whitespace()<CR>", "Strip whitespace" },
  },
  v = { ":vnew<CR>", "Vertical split" },
}, { prefix = "<Leader>" })

-- Visual (Leader)
wk.register({
  y = { '"*y', "Yank to clipboard" },
}, { prefix = "<Leader>", mode = "v" })
