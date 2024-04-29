return {
  'zapling/mason-conform.nvim',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  dependencies = {
    'williamboman/mason.nvim',
    'stevearc/conform.nvim',
  },
  config = function()
    require('mason-conform').setup()
  end,
}
