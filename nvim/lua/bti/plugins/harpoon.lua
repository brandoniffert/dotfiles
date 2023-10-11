return {
  "ThePrimeagen/harpoon",
  keys = {
    { "<Leader>a", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Harpoon (Add Mark)" },
    { "<Leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon" },
    { "<Leader>hn", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", desc = "Harpoon (1)" },
    { "<Leader>he", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", desc = "Harpoon (2)" },
    { "<Leader>hi", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", desc = "Harpoon (3)" },
    { "<Leader>ho", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", desc = "Harpoon (4)" },
  },
}
