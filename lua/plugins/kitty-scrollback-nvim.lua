return {
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackTest' },
    event = { 'User KittyScrollbackLaunch' },
    dev = true,
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^1.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ','
      require('kitty-scrollback').setup({
        custom = function()
          vim.print('customstuff')
        end,
      })
    end,
  },
}
