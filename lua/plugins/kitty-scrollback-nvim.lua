return {
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackTest' },
    event = { 'User KittyScrollbackLaunch' },
    dev = true,
    config = function()
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ','
      require('kitty-scrollback').setup({
        {
          callbacks = {
            after_ready = vim.schedule(function()
              vim.api.nvim_exec_autocmds('User', { pattern = 'IntroDone', modeline = false })
            end),
          },
        },
      })
    end,
  },
}
