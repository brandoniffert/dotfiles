---@type LazySpec
return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      sh = { "shellcheck" },
      yaml = { "yamllint" },
    }

    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      desc = "Run linters",
      group = vim.api.nvim_create_augroup("CustomRunLinters", { clear = true }),
      callback = function()
        local lint_status, lint = pcall(require, "lint")
        if lint_status then
          lint.try_lint()
        end
      end,
    })
  end,
}
