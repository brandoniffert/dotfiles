local M = {}

function M.has_plugin(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.has_ancestor_files(files, startpath)
  local path = startpath or vim.fs.dirname(vim.api.nvim_buf_get_name(0))

  local found = vim.fs.find(files, {
    upward = true,
    stop = vim.loop.os_homedir(),
    path = path,
  })

  return #found > 0 and found or nil
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.keymap(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M
