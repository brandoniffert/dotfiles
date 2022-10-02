local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local needs_bootstrap = vim.fn.isdirectory(install_path) == 0

if needs_bootstrap then
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.api.nvim_command("packadd packer.nvim")
end

require("packer").startup({
  function(use)
    use("lewis6991/impatient.nvim")
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim")
    use("nathom/filetype.nvim")

    -- Git
    use(require("bti.config.gitsigns"))
    use(require("bti.config.vim-fugitive"))

    -- Theme / UI
    use(require("bti.config.theme"))
    use(require("bti.config.nvim-web-devicons"))
    use(require("bti.config.heirline"))
    use("lukas-reineke/indent-blankline.nvim")

    -- Completion
    use(require("bti.config.completion"))

    -- File Explorer
    use(require("bti.config.nvim-tree"))

    -- LSP
    use(require("bti.config.lspconfig"))

    -- Fuzzy Finding
    use(require("bti.config.telescope"))
    use(require("bti.config.lightspeed"))

    -- Treesitter
    use(require("bti.config.nvim-treesitter"))

    -- Clipboard
    use(require("bti.config.vim-oscyank"))
    use(require("bti.config.nvim-neoclip"))

    -- Utility
    use(require("bti.config.loupe"))
    use(require("bti.config.comment"))
    use(require("bti.config.vim-eunuch"))
    use("alexghergh/nvim-tmux-navigation")
    use("tpope/vim-repeat")

    use(require("bti.config.which-key"))

    if needs_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
    },
    prompt_border = "rounded",
  },
})
