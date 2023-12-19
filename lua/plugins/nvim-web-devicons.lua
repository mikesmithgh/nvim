return {
  'nvim-tree/nvim-web-devicons',
  dev = false,
  priority = 1000,
  enabled = true,
  lazy = false,
  config = function()
    require('gruvsquirrel.plugins.nvim-web-devicons').setup()
  end,
}
