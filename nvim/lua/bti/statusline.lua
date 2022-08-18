local M = {}

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = require("catppuccin.palettes.mocha")

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)

    if not self.once then
      vim.api.nvim_create_autocmd("ModeChanged", { command = "redrawstatus" })
      self.once = true
    end
  end,

  static = {
    mode_names = {
      ["n"] = "NORMAL",
      ["no"] = "O-PENDING",
      ["nov"] = "O-PENDING",
      ["noV"] = "O-PENDING",
      ["no\22"] = "O-PENDING",
      ["niI"] = "NORMAL",
      ["niR"] = "NORMAL",
      ["niV"] = "NORMAL",
      ["nt"] = "NORMAL",
      ["ntT"] = "NORMAL",
      ["v"] = "VISUAL",
      ["vs"] = "VISUAL",
      ["V"] = "V-LINE",
      ["Vs"] = "V-LINE",
      ["\22"] = "V-BLOCK",
      ["\22s"] = "V-BLOCK",
      ["s"] = "SELECT",
      ["S"] = "S-LINE",
      ["\19"] = "S-BLOCK",
      ["i"] = "INSERT",
      ["ic"] = "INSERT",
      ["ix"] = "INSERT",
      ["R"] = "REPLACE",
      ["Rc"] = "REPLACE",
      ["Rx"] = "REPLACE",
      ["Rv"] = "V-REPLACE",
      ["Rvc"] = "V-REPLACE",
      ["Rvx"] = "V-REPLACE",
      ["c"] = "COMMAND",
      ["cv"] = "EX",
      ["ce"] = "EX",
      ["r"] = "REPLACE",
      ["rm"] = "MORE",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      ["t"] = "TERMINAL",
    },
    mode_colors = {
      n = colors.blue,
      i = colors.green,
      v = colors.mauve,
      V = colors.mauve,
      ["\22"] = colors.mauve,
      c = colors.peach,
      s = colors.teal,
      S = colors.teal,
      ["\19"] = colors.teal,
      R = colors.red,
      r = colors.red,
      ["!"] = colors.red,
      t = colors.red,
    },
  },

  provider = function(self)
    return "  " .. self.mode_names[self.mode] .. " "
  end,

  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return { fg = self.mode_colors[mode], bold = true }
  end,

  update = "ModeChanged",
}

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { bold = true },

  {
    provider = " ",
  },
  {
    provider = function(self)
      return self.status_dict.head
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
  },
}

local FileNamePrefix = {
  {
    provider = " ",
  },
  {
    provider = function(_)
      local basename = vim.fn.expand("%:h")

      if basename == "" or basename == "." then
        return ""
      else
        return vim.fn.substitute(vim.fn.fnamemodify(basename, ":~:."), "/$", "", "") .. "/"
      end
    end,

    hl = {
      fg = colors.overlay2,
    },
  },
}

local FileName = {
  {
    provider = function(_)
      return "%t"
    end,

    hl = {
      bold = true,
    },
  },
}

local FileFlags = {
  {
    condition = function(_)
      return vim.bo.modified
    end,

    provider = " ✕",

    hl = { fg = colors.red, bold = true },
  },
  {
    condition = function(_)
      return vim.bo.readonly
    end,

    provider = " [RO]",

    hl = { bold = true },
  },
  {
    condition = function()
      return vim.wo.spell
    end,

    provider = " SPELL",

    hl = { bold = true, fg = colors.orange },
  },
}

local Whitespace = utils.surround({ " ", " " }, nil, {
  condition = function(_)
    local is_modifiable = vim.bo.modifiable
    local has_bufname = vim.fn.bufname("%") ~= ""

    return is_modifiable and has_bufname
  end,

  provider = function(_)
    local has_trailing = vim.fn.search("\\s$", "nw") ~= 0
    local has_mixed = vim.bo.expandtab and vim.fn.search("\\v\\t", "nw") ~= 0

    if has_trailing and has_mixed then
      return "trailing/mixed"
    end

    if has_mixed then
      return "mixed"
    end

    if has_trailing then
      return "trailing"
    end

    return ""
  end,
})

local Diagnostics = utils.surround({ " ", " " }, nil, {
  condition = conditions.has_diagnostics,

  static = {
    error_icon = "•",
    warn_icon = "•",
    info_icon = "•",
    hint_icon = "•",
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors)
    end,
    hl = { fg = colors.red },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings)
    end,
    hl = { fg = colors.yellow },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info)
    end,
    hl = { fg = colors.blue },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = colors.teal },
  },
})

local FileEncodingFormat = {
  provider = function()
    local expected = "unix [utf-8]"
    local fmt = vim.bo.fileformat
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
    local fmt_enc = fmt .. " [" .. enc .. "]"

    if fmt_enc ~= expected then
      return fmt_enc
    end
  end,
}

local FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = { bold = true },
}

local LocationProgress = utils.surround({ " ", " " }, nil, {
  provider = function(_)
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    local total = vim.fn.line("$")
    local location = math.floor(line / total * 100) .. "%%"

    if line == 1 then
      location = "Top"
    elseif line == total then
      location = "Bot"
    end

    return string.format("%3d:%-3d", line, col) .. " " .. "%-3(" .. location .. "%)"
  end,

  hl = {
    fg = colors.subtext0,
  },
})

local SearchCount = utils.surround({ " ", " " }, nil, {
  condition = function(_)
    return vim.v.hlsearch == 1
  end,

  provider = function(_)
    local searchcount = vim.fn.searchcount({ maxcount = 0 })
    return "[" .. searchcount["current"] .. "/" .. searchcount["total"] .. "]"
  end,
})

local StatusLine = {
  { ViMode },
  { Git },
  { FileNamePrefix },
  { FileName },
  { FileFlags },
  { provider = "%=" },
  { Whitespace },
  { Diagnostics },
  { FileEncodingFormat },
  { FileType },
  { LocationProgress },
  { SearchCount },
}

local SpecialStatusLine = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "help", "quickfix" },
      filetype = { "^git.*", "fugitive", "checkhealth", "NvimTree" },
    })
  end,

  init = utils.pick_child_on_condition,

  hl = {
    bold = true,
  },

  {
    condition = function()
      return vim.bo.buftype == "help"
    end,

    { provider = "Help - " },
    { FileName },
    { provider = "%=" },
  },

  {
    condition = function()
      return vim.bo.buftype == "quickfix"
    end,

    { provider = 'Quickfix - %{get(w:,"quickfix_title","")}' },
    { provider = "%=" },
  },

  {
    condition = function()
      return string.match(vim.bo.filetype, "^git.*")
    end,

    { provider = "git - " },
    { FileName },
    { provider = "%=" },
  },

  {
    condition = function()
      return vim.bo.filetype == "NvimTree"
    end,

    { provider = "NvimTree" },
    { provider = "%=" },
  },

  {
    condition = function()
      return true
    end,

    { FileName },
    { provider = "%=" },
  },
}

local SimpleStatusLine = {
  { FileNamePrefix },
  { FileName },
  { FileFlags },
  { provider = "%=" },
}

local ActiveStatusLine = {
  condition = function()
    return conditions.is_active()
  end,

  hl = {
    fg = colors.text,
    bg = "#242438",
  },

  init = utils.pick_child_on_condition,

  SpecialStatusLine,
  StatusLine,
}

local InactiveStatusLine = {
  condition = function()
    return not conditions.is_active()
  end,

  init = utils.pick_child_on_condition,

  hl = {
    fg = colors.text,
    bg = colors.mantle,
  },

  SpecialStatusLine,
  SimpleStatusLine,
}

local BlurredStatusLine = {
  hl = {
    fg = colors.text,
    bg = colors.mantle,
  },

  init = utils.pick_child_on_condition,

  SpecialStatusLine,
  SimpleStatusLine,
}

M.activate = function()
  require("heirline").setup({
    init = utils.pick_child_on_condition,
    InactiveStatusLine,
    ActiveStatusLine,
  })
end

M.deactivate = function()
  require("heirline").setup(BlurredStatusLine)
end

return M
