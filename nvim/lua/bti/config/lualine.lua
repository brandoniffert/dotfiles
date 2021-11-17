-- Custom components
local components = {
  filename_prefix = function()
    return vim.fn['bti#statusline#filename_prefix']()
  end,

  modified = function()
    return vim.fn['bti#statusline#modified']()
  end,

  readonly = function()
    return vim.fn['bti#statusline#readonly']()
  end,

  whitespace = function()
    return vim.fn['bti#statusline#whitespace']()
  end,

  ffenc = function()
    return vim.fn['bti#statusline#ffenc']()
  end
}

-- Custom extensions
local extensions = {
  nvim_tree = {
    filetypes = { 'NvimTree' },
    sections = {
      lualine_a = { '[[ NvimTree ]]' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    }
  },
  help = {
    filetypes = { 'help' },
    sections = {
      lualine_a = { '[[ Help ]]' },
      lualine_b = {},
      lualine_c = { '%t' },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    }
  },
}

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 1
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, padding = { left = 1, right = 2 } },
    },
    lualine_b = {
      { 'FugitiveHead', icon = '', color = 'CursorLine' },
      { 'diff', color = 'CursorLine', colored = false, padding = { left = 0, right = 1 }},
    },
    lualine_c = {
      { components.filename_prefix, padding = { left = 1, right = 0 } },
      { '[[ ]]', padding = 0, cond = function () return components.filename_prefix() == ''; end },
      { '%t', padding = 0, color = { fg = 'white', gui = 'bold' }},
      { components.readonly, padding = 0, color = { gui = 'bold' } },
      { components.modified, padding = 0, color = { fg = bti.util.colors.red, gui = 'bold' } },
    },
    lualine_x = {
      { components.whitespace },
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        symbols = { error = '•', warn = '•', info = '•', hint = '•' },
      },
      { components.ffenc },
      { 'filetype' }
    },
    lualine_y = {
      { 'progress', color = 'CursorLine' },
    },
    lualine_z = {
      { 'location', separator = { right = '' }, padding = { left = 2 } },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { components.filename_prefix, color = { fg = 'white' }, padding = { left = 0, right = 0 } },
      { '%t', padding = 0, color = { fg = 'white' }},
      { components.modified, padding = 0, color = { fg = 'white', gui = 'bold' } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {
    extensions.nvim_tree,
    extensions.help,
  }
}

local augroup = bti.vim.augroup
local autocmd = bti.vim.autocmd

augroup('LuaLineAutocmds', function ()
  autocmd('OptionSet', 'showtabline', 'set showtabline=1')
end)
