return {
  'sindrets/diffview.nvim',
  enabled = true,
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('diffview').setup()
  end,
}
