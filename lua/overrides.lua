local M = {}

M.setup = function()
  if vim.env.TERM_PROGRAM == 'Apple_Terminal' then
    vim.opt.termguicolors = false
    vim.cmd([[colorscheme default]])
  end

  if vim.env.TERM ~= 'xterm-kitty' then
    vim.o.fillchars = ''
  end
end

return M
