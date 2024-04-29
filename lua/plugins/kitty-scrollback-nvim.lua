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
        search = {
          callbacks = {
            after_ready = function()
              vim.defer_fn(function()
                vim.api.nvim_feedkeys('?', 'n', false)
              end, 100)
            end,
          },
        },
      })
    end,
  },
}
