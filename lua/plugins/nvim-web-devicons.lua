return {
  'nvim-tree/nvim-web-devicons',
  dev = false,
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('gruvsquirrel.plugins.nvim-web-devicons').setup()
  end,
}
