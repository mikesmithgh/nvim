local M = {}

M.setup = function()
  vim.hl = vim.highlight -- vim.highlight removed in 0.11

  -- vim.fn.sign_define deprecated in 0.11 removed in 0.12 in favor of vim.diagnostic.config
  vim.fn.sign_define('DiagnosticSignError', { texthl = 'DiagnosticSignError', text = '×', numhl = 'DiagnosticSignError' })
  vim.fn.sign_define('DiagnosticSignWarn', { texthl = 'DiagnosticSignWarn', text = '▲', numhl = '' })
  vim.fn.sign_define('DiagnosticSignHint', { texthl = 'DiagnosticSignHint', text = '⚑', numhl = '' })
  vim.fn.sign_define('DiagnosticSignInfo', { texthl = 'DiagnosticSignInfo', text = '', numhl = '' })
end

return M
