local M = {}

M.plugin_spec_finder = function()
  require("fzf-lua").fzf_exec("rg -t lua --vimgrep -- '^\\s*-- PLUGIN' | sed 's/-- PLUGIN://g'", {
    prompt = "Plugins❯ ",
    actions = require("fzf-lua").defaults.actions.files,
    previewer = false,
    fn_transform = function(x)
      local parts = {}
      for part in x:gmatch("%S+") do
        table.insert(parts, part:match("^%s*(.-)%s*$"))
      end

      local loc = parts[1]
      local name = parts[2]

      loc = loc .. (" "):rep(45 - #loc)

      local entry = loc .. name

      return require("fzf-lua").make_entry.file(entry, { file_icons = true, color_icons = true })
    end,
  })
end

return M
