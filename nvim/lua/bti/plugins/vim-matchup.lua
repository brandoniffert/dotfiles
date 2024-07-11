---@type LazySpec
return {
  "andymass/vim-matchup",
  init = function()
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_matchparen_enabled = 0
  end,
  config = true,
}
