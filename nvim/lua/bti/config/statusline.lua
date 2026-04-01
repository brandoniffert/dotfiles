local M = {}

local colors = require("bti.theme").colors
local icons = require("bti.theme").icons

-------------------------------------------------------------
-- Highlights
-------------------------------------------------------------

local function setup_highlights()
  local hl = vim.api.nvim_set_hl
  local bg = colors.base1

  -- Mode
  hl(0, "StlModeNormal", { fg = colors.blue, bg = bg, bold = true })
  hl(0, "StlModeInsert", { fg = colors.green, bg = bg, bold = true })
  hl(0, "StlModeVisual", { fg = colors.mauve, bg = bg, bold = true })
  hl(0, "StlModeReplace", { fg = colors.red, bg = bg, bold = true })
  hl(0, "StlModeCommand", { fg = colors.peach, bg = bg, bold = true })
  hl(0, "StlModeSelect", { fg = colors.teal, bg = bg, bold = true })
  hl(0, "StlModeTerminal", { fg = colors.red, bg = bg, bold = true })

  -- Statusline
  hl(0, "StlBase", { fg = colors.text, bg = bg })
  hl(0, "StlProgress", { fg = colors.overlay2, bg = bg })
  hl(0, "StlPath", { fg = colors.overlay2, bg = bg })
  hl(0, "StlFile", { fg = colors.text, bg = bg, bold = true })
  hl(0, "StlModified", { fg = colors.red, bg = bg, bold = true })
  hl(0, "StlReadonly", { fg = colors.red, bg = bg, bold = true })
  hl(0, "StlSpell", { fg = colors.lavender, bg = bg, bold = true })
  hl(0, "StlFiletype", { fg = colors.text, bg = bg, bold = true })
  hl(0, "StlLocation", { fg = colors.subtext0, bg = bg })
  hl(0, "StlSpecial", { fg = colors.text, bg = bg, bold = true })
  hl(0, "StlDiagError", { fg = colors.red, bg = bg })
  hl(0, "StlDiagWarn", { fg = colors.yellow, bg = bg })
  hl(0, "StlDiagInfo", { fg = colors.blue, bg = bg })
  hl(0, "StlDiagHint", { fg = colors.teal, bg = bg })
  hl(0, "StlGitBranch", { fg = colors.subtext0, bg = bg })
  hl(0, "StlGitAdded", { fg = colors.green, bg = bg })
  hl(0, "StlGitChanged", { fg = colors.yellow, bg = bg })
  hl(0, "StlGitRemoved", { fg = colors.red, bg = bg })

  -- Winbar (no bg, inherits window background)
  hl(0, "WinBarPath", { fg = colors.overlay2 })
  hl(0, "WinBarFile", { fg = colors.text, bold = true })
  hl(0, "WinBarModified", { fg = colors.red, bold = true })
  hl(0, "WinBarReadonly", { fg = colors.red, bold = true })
  hl(0, "WinBarSpell", { fg = colors.lavender, bold = true })

  -- Tabline
  hl(0, "TabActive", { fg = colors.text, bg = bg, bold = true })
  hl(0, "TabInactive", { fg = colors.overlay2, bg = bg })
end

-------------------------------------------------------------
-- Mode
-------------------------------------------------------------

local mode_names = {
  n = "NORMAL",
  no = "O-PENDING",
  nov = "O-PENDING",
  noV = "O-PENDING",
  ["no\22"] = "O-PENDING",
  niI = "NORMAL",
  niR = "NORMAL",
  niV = "NORMAL",
  nt = "NORMAL",
  ntT = "NORMAL",
  v = "VISUAL",
  vs = "VISUAL",
  V = "V-LINE",
  Vs = "V-LINE",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  i = "INSERT",
  ic = "INSERT",
  ix = "INSERT",
  R = "REPLACE",
  Rc = "REPLACE",
  Rx = "REPLACE",
  Rv = "V-REPLACE",
  Rvc = "V-REPLACE",
  Rvx = "V-REPLACE",
  c = "COMMAND",
  cv = "EX",
  ce = "EX",
  r = "REPLACE",
  rm = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  t = "TERMINAL",
}

local mode_hls = {
  n = "StlModeNormal",
  i = "StlModeInsert",
  v = "StlModeVisual",
  V = "StlModeVisual",
  ["\22"] = "StlModeVisual",
  c = "StlModeCommand",
  s = "StlModeSelect",
  S = "StlModeSelect",
  ["\19"] = "StlModeSelect",
  R = "StlModeReplace",
  r = "StlModeReplace",
  ["!"] = "StlModeTerminal",
  t = "StlModeTerminal",
}

local function mode()
  local m = vim.fn.mode(1)
  local name = mode_names[m] or m
  local hl = mode_hls[m:sub(1, 1)] or "StlModeNormal"
  return "%#" .. hl .. "#  " .. name .. " "
end

local function escape_stl(s)
  return s:gsub("%%", "%%%%")
end

local function git()
  local dict = vim.b.gitsigns_status_dict
  if not dict then
    return ""
  end
  local parts = { "%#StlGitBranch# " .. escape_stl(dict.head or "") }
  if (dict.added or 0) > 0 then
    parts[#parts + 1] = " %#StlGitAdded#+" .. dict.added
  end
  if (dict.changed or 0) > 0 then
    parts[#parts + 1] = " %#StlGitChanged#~" .. dict.changed
  end
  if (dict.removed or 0) > 0 then
    parts[#parts + 1] = " %#StlGitRemoved#-" .. dict.removed
  end
  parts[#parts + 1] = " %#StlGitBranch#"
  return table.concat(parts)
end

-------------------------------------------------------------
-- File info (shared by statusline and winbar)
-------------------------------------------------------------

local stl_hl = {
  path = "StlPath",
  file = "StlFile",
  modified = "StlModified",
  readonly = "StlReadonly",
  spell = "StlSpell",
}

local winbar_hl = {
  path = "WinBarPath",
  file = "WinBarFile",
  modified = "WinBarModified",
  readonly = "WinBarReadonly",
  spell = "WinBarSpell",
}

local function file_info(hl)
  local parts = {}
  local dir = vim.fn.expand("%:h")
  if dir ~= "" and dir ~= "." then
    parts[#parts + 1] = "%#" .. hl.path .. "# " .. escape_stl(vim.fn.fnamemodify(dir, ":~:.")) .. "/"
  else
    parts[#parts + 1] = " "
  end
  parts[#parts + 1] = "%#" .. hl.file .. "#%t"
  if vim.bo.modified then
    parts[#parts + 1] = "%#" .. hl.modified .. "# " .. icons.circle
  end
  if vim.bo.readonly then
    parts[#parts + 1] = "%#" .. hl.readonly .. "# RO"
  end
  if vim.wo.spell and vim.bo.filetype ~= "markdown" then
    parts[#parts + 1] = "%#" .. hl.spell .. "# SPELL"
  end
  return table.concat(parts)
end

-------------------------------------------------------------
-- Right-side components
-------------------------------------------------------------

local diag_hl = {
  [vim.diagnostic.severity.ERROR] = "StlDiagError",
  [vim.diagnostic.severity.WARN] = "StlDiagWarn",
  [vim.diagnostic.severity.INFO] = "StlDiagInfo",
  [vim.diagnostic.severity.HINT] = "StlDiagHint",
}

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  if not next(counts) then
    return ""
  end
  local parts = { " " }
  for _, sev in ipairs({
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
  }) do
    local n = counts[sev]
    if n and n > 0 then
      parts[#parts + 1] = "%#" .. diag_hl[sev] .. "#" .. icons.circle_sm .. n
    end
  end
  parts[#parts + 1] = " "
  return table.concat(parts)
end

local function lsp_progress()
  local status = vim.lsp.status()
  if status == "" then
    return ""
  end
  return "%#StlProgress# " .. escape_stl(status) .. " "
end

local function encoding()
  local fmt = vim.bo.fileformat
  local enc = vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
  if fmt ~= "unix" or enc ~= "utf-8" then
    return "%#StlBase#" .. escape_stl(fmt) .. " [" .. escape_stl(enc) .. "] "
  end
  return ""
end

local function filetype()
  local ft = vim.bo.filetype
  if ft == "" then
    return ""
  end
  return "%#StlFiletype#" .. escape_stl(ft) .. " "
end

local location = "%#StlLocation# %3l:%-3c %P "

-------------------------------------------------------------
-- Special statusline for non-standard buffers
-------------------------------------------------------------

local function special_statusline()
  local bt = vim.bo.buftype
  local ft = vim.bo.filetype

  if bt == "help" then
    return "%#StlSpecial#Help - %t%="
  elseif bt == "quickfix" then
    return '%#StlSpecial#Quickfix - %{get(w:,"quickfix_title","")}%='
  elseif ft:match("^gitcommit") then
    return "%#StlSpecial#git - %t%="
  elseif ft == "snacks_picker_list" then
    return "%#StlSpecial#Explorer%="
  elseif bt == "nofile" or ft == "checkhealth" then
    return "%#StlSpecial#%t%="
  end
  return nil
end

-------------------------------------------------------------
-- Public: statusline, winbar, tabline
-------------------------------------------------------------

function M.statusline()
  local special = special_statusline()
  if special then
    return special
  end

  return table.concat({
    mode(),
    git(),
    file_info(stl_hl),
    "%#StlBase#%=",
    lsp_progress(),
    diagnostics(),
    encoding(),
    filetype(),
    location,
  })
end

function M.winbar()
  return file_info(winbar_hl) .. "%="
end

function M.tabline()
  local tabs = vim.api.nvim_list_tabpages()
  if #tabs < 2 then
    return ""
  end

  local current = vim.api.nvim_get_current_tabpage()
  local parts = {}
  for i, tab in ipairs(tabs) do
    local hl = tab == current and "%#TabActive#" or "%#TabInactive#"
    parts[#parts + 1] = hl .. "%" .. i .. "T " .. i .. " %T"
  end
  parts[#parts + 1] = "%="
  return table.concat(parts)
end

-------------------------------------------------------------
-- Setup
-------------------------------------------------------------

local disabled_winbar_bt = {
  prompt = true,
  nofile = true,
  help = true,
  quickfix = true,
  terminal = true,
}
local disabled_winbar_ft = { Trouble = true }

function M.setup()
  setup_highlights()

  local group = vim.api.nvim_create_augroup("bti_statusline", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = setup_highlights,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "GitSignsUpdate",
    command = "redrawstatus",
  })

  local last_progress_redraw = 0
  vim.api.nvim_create_autocmd("LspProgress", {
    group = group,
    callback = function(args)
      local kind = (args.data or {}).params and args.data.params.value and args.data.params.value.kind
      if kind == "end" then
        vim.defer_fn(function()
          vim.cmd.redrawstatus()
        end, 1000)
        return
      end
      local now = vim.uv.hrtime() / 1e6
      if now - last_progress_redraw > 100 then
        last_progress_redraw = now
        vim.cmd.redrawstatus()
      end
    end,
  })

  vim.o.statusline = "%{%v:lua.require('bti.config.statusline').statusline()%}"
  vim.o.tabline = "%{%v:lua.require('bti.config.statusline').tabline()%}"

  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "FileType" }, {
    group = group,
    callback = function(args)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(args.buf) then
          return
        end
        local bt = vim.bo[args.buf].buftype
        local ft = vim.bo[args.buf].filetype
        for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
          if disabled_winbar_bt[bt] or disabled_winbar_ft[ft] then
            vim.wo[win].winbar = ""
          else
            vim.wo[win].winbar = "%{%v:lua.require('bti.config.statusline').winbar()%}"
          end
        end
      end)
    end,
  })
end

return M
