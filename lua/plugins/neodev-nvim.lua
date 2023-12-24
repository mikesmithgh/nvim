return {
  'folke/neodev.nvim',
  enabled = true,
  lazy = true,
  config = function()
    require('neodev').setup()
  end,
}
