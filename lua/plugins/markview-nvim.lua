return {
  'OXY2DEV/markview.nvim',
  enabled = true,
  lazy = false,
  config = function()
    require('markview').setup({
      preview = {
        enable = false,
      },
    })
  end,
}
