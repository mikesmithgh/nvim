return {
  'OXY2DEV/markview.nvim',
  enabled = true,
  cmd = { 'Markview' },
  lazy = true,
  config = function()
    require('markview').setup()
  end,
}
