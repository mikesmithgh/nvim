return {
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
    event = { 'User KittyScrollbackLaunch' },
    dev = true,
    config = function()
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ','
      require('kitty-scrollback').setup()
    end,
  },
}
