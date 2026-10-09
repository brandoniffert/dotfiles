local M = {
  name = "herdr",
  protocol_version = "3.0.0",
}

local function exec_json(args)
  local bin = vim.env.HERDR_BIN_PATH
  if bin == nil or bin == "" then
    bin = "herdr"
  end

  local ok, res = pcall(function()
    return vim.system({ bin, unpack(args) }, { text = true }):wait()
  end)
  if not ok or res.code ~= 0 or not res.stdout or res.stdout == "" then
    return nil
  end

  local decoded_ok, decoded = pcall(vim.json.decode, res.stdout)
  if not decoded_ok or type(decoded) ~= "table" or type(decoded.result) ~= "table" then
    return nil
  end
  return decoded.result
end

local function split(direction)
  local split_direction = (direction == "left" or direction == "right") and "right" or "down"
  local need_swap = ({ left = "right", up = "down" })[direction]

  local result = exec_json({ "pane", "split", "--direction", split_direction, "--current", "--focus" })
  if not result or type(result.pane) ~= "table" or result.pane.pane_id == nil then
    return false
  end
  if not need_swap then
    return true
  end

  local swap = exec_json({ "pane", "swap", "--direction", need_swap, "--current" })
  return swap ~= nil and swap.swap ~= nil
end

function M.detect()
  if vim.env.HERDR_ENV == nil or vim.env.HERDR_ENV == "" then
    return false
  end

  -- GUI clients (e.g. neovide) inherit HERDR_ENV but aren't inside a herdr pane
  local ui = vim.tbl_filter(function(u)
    return u.chan == 1
  end, vim.api.nvim_list_uis())[1]
  return not (ui ~= nil and not ui.stdin_tty and not ui.stdout_tty)
end

function M.move(direction, opts)
  opts = opts or {}
  local result = exec_json({ "pane", "focus", "--direction", direction, "--current" })
  if result and type(result.focus) == "table" and result.focus.changed == true then
    return true
  end
  if opts.at_edge == "split" then
    return split(direction)
  end
  return false
end

function M.resize(direction, opts)
  opts = opts or {}
  local result = exec_json({
    "pane",
    "resize",
    "--direction",
    direction,
    "--amount",
    tostring(opts.amount or 3),
    "--current",
  })
  return result ~= nil and type(result.resize) == "table" and result.resize.changed == true
end

return M
