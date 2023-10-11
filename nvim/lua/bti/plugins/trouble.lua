return {
  "folke/trouble.nvim",
  keys = {
    { "<Leader>xx", "<cmd>TroubleToggle<CR>", desc = "Toggle" },
    { "<Leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
    { "<Leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Document diagnostics" },
    { "<Leader>xr", "<cmd>TroubleToggle lsp_references<CR>", desc = "References" },
  },
  opts = {
    use_diagnostic_signs = true,
  },
}
