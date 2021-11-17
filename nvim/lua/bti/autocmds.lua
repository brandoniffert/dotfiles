local autocmds = {}

local ownsyntax_flag = 'bti_ownsyntax'

local winhighlight_blurred = table.concat({
  'EndOfBuffer:InactiveWindow',
  'IncSearch:InactiveWindow',
  'Normal:InactiveWindow',
  'NormalNC:InactiveWindow',
  'Search:InactiveWindow',
  'SignColumn:InactiveWindow',
}, ',')

-- As described in a7e4d8b8383a375d124, `ownsyntax` resets spelling
-- settings, so we capture and restore them. Note that there is some trickiness
-- here because multiple autocmds can trigger "focus" or "blur" operations; this
-- means that we can't just naively save and restore: we have to use a flag to
-- make sure that we only capture the initial state.
local ownsyntax = function(active)
  local flag = vim.w[ownsyntax_flag]

  if active and flag == false then
    -- We are focussing; restore previous settings.
    vim.cmd('ownsyntax on')

    vim.wo.spell = vim.w.spell or false
    vim.bo.spellcapcheck = vim.w.spellcapcheck or ''
    vim.bo.spellfile = vim.w.spellfile or ''
    vim.bo.spelllang = vim.w.spelllang or 'en'

    -- Set flag to show that we have restored the captured options.
    vim.w[ownsyntax_flag] = true
  elseif not active and vim.bo.filetype ~= '' and flag ~= false then
    -- We are blurring; save settings for later restoration.
    vim.w.spell = vim.wo.spell
    vim.w.spellcapcheck = vim.bo.spellcapcheck
    vim.w.spellfile = vim.bo.spellfile
    vim.w.spelllang = vim.bo.spelllang

    vim.cmd('ownsyntax off')

    -- Suppress spelling in blurred buffer.
    vim.wo.spell = false

    -- Set flag to show that we have captured options.
    vim.w[ownsyntax_flag] = false
  end
end

local focus_window = function()
  local filetype = vim.bo.filetype

  -- Turn on relative numbers, unless user has explicitly changed numbering.
  if filetype ~= '' and autocmds.number_blacklist[filetype] ~= true then
    vim.wo.number = true
    vim.wo.relativenumber = true
  end

  if filetype ~= '' and autocmds.winhighlight_filetype_blacklist[filetype] ~= true then
    vim.wo.winhighlight = ''
    vim.cmd('TSBufEnable highlight')
  end

  if filetype ~= '' and autocmds.ownsyntax_filetypes[filetype] ~= true then
    ownsyntax(true)
  end

  if filetype == '' then
    vim.wo.list = true
  else
    local list = autocmds.list_filetypes[filetype]
    vim.wo.list = list == nil and true or list
  end

  local conceallevel = autocmds.conceallevel_filetypes[filetype] or 2
  vim.wo.conceallevel = conceallevel
end

local blur_window = function()
  local filetype = vim.bo.filetype

  -- Turn off relative numbers (and turn on non-relative numbers), unless user
  -- has explicitly changed the numbering.
  if filetype ~= '' and autocmds.number_blacklist[filetype] ~= true then
    vim.wo.number = true
    vim.wo.relativenumber = false
  end

  if filetype == '' or autocmds.winhighlight_filetype_blacklist[filetype] ~= true then
    vim.wo.winhighlight = winhighlight_blurred
    vim.cmd('TSBufDisable highlight')
  end

  if filetype == '' or autocmds.ownsyntax_filetypes[filetype] ~= true then
    ownsyntax(false)
  end

  if filetype == '' then
    vim.wo.list = false
  else
    local list = autocmds.list_filetypes[filetype]
    if list == nil then
      vim.wo.list = false
    else
      vim.wo.list = list
    end
  end

  if filetype == '' or autocmds.conceallevel_filetypes[filetype] == nil then
    vim.wo.conceallevel = 0
  end
end

local enable_statusline = function ()
  if package.loaded['lualine'] then
    vim.go.statusline = "%{%v:lua.require'lualine'.setup()%}"
  end
end

local disable_statusline = function ()
  if package.loaded['lualine'] then
    vim.go.statusline = require'lualine'.statusline(false)
  end
end

autocmds.buf_enter = function()
  focus_window()
end

autocmds.focus_gained = function()
  local filetype = vim.bo.filetype

  if filetype ~= '' then
    focus_window()
  end

  enable_statusline()
end

autocmds.focus_lost = function()
  blur_window()
  disable_statusline()
end

autocmds.win_enter = function()
  focus_window()
end

autocmds.win_leave = function()
  blur_window()
end

-- Don't mess with 'conceallevel' for these.
autocmds.conceallevel_filetypes = {
  ['help'] = 2,
  ['json'] = 0,
}

-- Don't use 'winhighlight' to make these filetypes seem blurred.
autocmds.winhighlight_filetype_blacklist = {
  ['diff'] = true,
  ['fugitiveblame']= true,
  ['NvimTree'] = true,
  ['packer'] = true,
  ['qf'] = true,
}

-- Force 'list' (when `true`) or 'nolist' (when `false`) for these.
autocmds.list_filetypes = {
  ['help'] = false,
}

-- Don't mess with numbers in these filetypes.
autocmds.number_blacklist = {
  ['NvimTree'] = true,
  ['diff'] = true,
  ['fugitiveblame']= true,
  ['help'] = true,
  ['qf'] = true,
}

-- Don't do "ownsyntax off" for these.
autocmds.ownsyntax_filetypes = {
  ['NvimTree'] = true,
  ['help'] = true,
  ['packer'] = true,
  ['qf'] = true,
}

return autocmds
