---@type LazySpec
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<Leader>ha", function()
      harpoon:list():append()
    end, { desc = "Harpoon (Append)" })

    vim.keymap.set("n", "<Leader>hc", function()
      harpoon:list():clear()
    end, { desc = "Harpoon (Clear)" })

    vim.keymap.set("n", "<Leader>hh", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon (Toggle)" })

    vim.keymap.set("n", "<Leader>hn", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon (1)" })

    vim.keymap.set("n", "<Leader>he", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon (2)" })

    vim.keymap.set("n", "<Leader>hi", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon (3)" })

    vim.keymap.set("n", "<Leader>ho", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon (4)" })
  end,
}
