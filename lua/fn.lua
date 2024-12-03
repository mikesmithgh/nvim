local M = {}

M.default_format_file = function()
  local current_view = vim.fn.winsaveview()
  vim.cmd.normal({ 'gg=G', bang = true })
  vim.fn.winrestview(current_view)
end

return M
