local M = {}

M.setup = function()
  vim.api.nvim_create_user_command('W', function(opts)
    if opts.bang then
      vim.cmd('w !sudo -A tee %')
    else
      vim.cmd.write()
    end
  end, {
    bang = true,
    bar = false,
    register = false,
  })
end

return M
