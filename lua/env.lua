local M = {}

M.setup = function()
  vim.env.SUDO_ASKPASS = '/opt/homebrew/bin/ssh-askpass'
end

return M

