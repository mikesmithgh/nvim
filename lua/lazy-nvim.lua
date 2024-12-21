local M = {}

M.init = function()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { out, 'WarningMsg' },
        { '\nPress any key to exit...' },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)
end

M.setup = function()
  require('lazy').setup('plugins', {
    dev = {
      -- directory where you store your local plugin projects
      path = '~/gitrepos/',
      ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
      patterns = {
        'mikesmithgh',
      },
      fallback = true, -- Fallback to git when local plugin doesn't exist
    },
    defaults = {
      lazy = false,
    },
    spec = {
      -- import your plugins
      { import = 'plugins' },
    },
    ui = {
      border = 'rounded',
    },
    install = {
      -- install missing plugins on startup. This doesn't increase startup time.
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { 'gruvsquirrel', 'gruvbox', 'retrobox' },
    },
    checker = { enabled = false },
  })
end

return M
