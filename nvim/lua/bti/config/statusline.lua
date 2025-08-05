local M = {}

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = require("bti.theme").colors
local icons = require("bti.theme").icons

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)

    if not self.once then
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:*o",
        command = "redrawstatus",
      })
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
      fg = colors.text,
      bold = true,
    },
  },
}

local FileFlags = {
  {
    condition = function(_)
      return vim.bo.modified
    end,

    provider = " " .. icons.circle,

    hl = { fg = colors.red, bold = true },
  },
  {
    condition = function(_)
      return vim.bo.readonly
    end,

    provider = " RO",

    hl = { fg = colors.red, bold = true },
  },
  {
    condition = function()
      local filetype = vim.bo.filetype

      local filetype_blacklist = {
        ["markdown"] = true,
      }

      return vim.wo.spell and filetype_blacklist[filetype] ~= true
    end,

    provider = " SPELL",

    hl = { bold = true, fg = colors.lavender },
  },
}

local Diagnostics = utils.surround({ " ", " " }, nil, {
  condition = conditions.has_diagnostics,

  static = {
    error_icon = icons.circle_sm,
    warn_icon = icons.circle_sm,
    info_icon = icons.circle_sm,
    hint_icon = icons.circle_sm,
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

local ActiveStatusLine = {
  { ViMode },
  { Git },
  { FileNamePrefix },
  { FileName },
  { FileFlags },
  { provider = "%=" },
  { Diagnostics },
  { FileEncodingFormat },
  { FileType },
  { LocationProgress },
}

local SpecialStatusLine = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "help", "quickfix" },
      filetype = { "^gitcommit", "checkhealth" },
    })
  end,

  fallthrough = false,

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
      return string.match(vim.bo.filetype, "^gitcommit")
    end,

    { provider = "git - " },
    { FileName },
    { provider = "%=" },
  },

  {
    condition = function()
      return vim.bo.filetype == "snacks_picker_list"
    end,

    { provider = "Explorer" },
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

local StatusLine = {
  hl = {
    fg = colors.text,
    bg = colors.base1,
  },

  fallthrough = false,

  SpecialStatusLine,
  ActiveStatusLine,
}

local WinBar = {
  SimpleStatusLine,
}

local TabPage = {
  provider = function(self)
    return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
  end,

  hl = function(self)
    if self.is_active then
      return {
        fg = colors.text,
        bold = true,
      }
    else
      return {
        fg = colors.overlay2,
      }
    end
  end,
}

local TabPages = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,

  utils.make_tablist(TabPage),
  { provider = "%=" },
}

local TabLine = { TabPages }

M.setup = function()
  require("heirline").setup({
    statusline = {
      StatusLine,
    },

    winbar = {
      WinBar,
    },

    tabline = {
      TabLine,
    },

    opts = {
      disable_winbar_cb = function(args)
        local buf = args.buf
        local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix", "terminal" }, vim.bo[buf].buftype)
        local filetype = vim.tbl_contains({ "Trouble" }, vim.bo[buf].filetype)

        return buftype or filetype
      end,
    },
  })
end

return M
