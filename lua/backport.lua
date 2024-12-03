local M = {}

M.setup = function()
  vim.hl = vim.highlight -- vim.highlight removed in 0.11
end

return M
