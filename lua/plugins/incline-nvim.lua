return {
  'b0o/incline.nvim',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('gruvsquirrel.plugins.incline-nvim').setup() -- invokes require('incline').setup()
  end,
}
