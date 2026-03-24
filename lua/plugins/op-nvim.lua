return {
  'mrjones2014/op.nvim',
  build = 'make install',
  enabled = true,
  lazy = true,
  config = function()
    require('op').setup()
  end,
}
