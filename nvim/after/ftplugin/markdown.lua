if vim.bo.buftype ~= "nofile" then
  vim.opt_local.conceallevel = 0
  vim.opt_local.formatoptions:remove("t")
  vim.opt_local.spell = true
end
