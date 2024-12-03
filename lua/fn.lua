local M = {}

M.default_format_file = function()
  vim.cmd.normal({ 'gg=G``', bang = true })
end

return M
