local nmap = bti.vim.nmap
local nnoremap = bti.vim.nnoremap
local xnoremap = bti.vim.xnoremap
local vnoremap = bti.vim.vnoremap
local wk = require("which-key")

-- Clear search highlight
nmap("<CR>", "<Plug>(LoupeClearHighlight)")

-- Navigate over wrapped lines
nnoremap("j", "gj")
nnoremap("k", "gk")

-- Use hjkl for switching between splits
nnoremap("<C-h>", "<C-W>h")
nnoremap("<C-j>", "<C-W>j")
nnoremap("<C-k>", "<C-W>k")
nnoremap("<C-l>", "<C-W>l")

-- Use arrow keys for tab navigation
nnoremap("<Left>", ":tabp<CR>")
nnoremap("<Right>", ":tabn<CR>")

-- Easy indent/outdent
nnoremap("<Tab>", ">>")
nnoremap("<S-Tab>", "<<")
vnoremap("<Tab>", ">gv")
vnoremap("<S-Tab>", "<gv")

-- Split lines (opposite of J)
nnoremap("|", ":<c-u>call bti#functions#break_here()<CR>", { silent = true })

-- Don't replace register with text that was pasted over
xnoremap("p", "p:if v:register == '\"'<bar>let @@=@0<bar>endif<CR>", { silent = true })

wk.setup({
  show_help = false,
  plugins = { spelling = true },
  key_labels = { ["<leader>"] = "SPC" },
})

local leader = {
  ["\\"] = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree" },
  ["<Leader>"] = { ":<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>", "Last file" },
  ["<CR>"] = { "<cmd>lua require('bti.util.telescope').find_files()<CR>", "Files" },
  e = { ':edit <C-R>=expand("%:p:h") . "/"<CR>', "Edit File (Same Directory)" },
  f = {
    name = "+find",
    b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
    c = { "<cmd>Telescope commands<CR>", "Commands" },
    f = { "<cmd>lua require('bti.util.telescope').find_files()<CR>", "Files" },
    F = { "<cmd>lua require('bti.util.telescope').find_all_files()<CR>", "Files (All)" },
    g = { "<cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<CR>", "Grep" },
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
  p = { ":*p", "Paste from clipboard" },
  q = { "<cmd>:q<CR>", "Quit" },
  Q = { "<cmd>:q!<CR>", "Quit without saving" },
  u = {
    name = "+util",
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
  w = { "<cmd>:w<CR>", "Write" },
}

local leader_visual = {
  y = { '"*y', "Yank to clipboard" },
}

wk.register(leader, { prefix = "<Leader>" })
wk.register(leader_visual, { prefix = "<Leader>", mode = "v" })
