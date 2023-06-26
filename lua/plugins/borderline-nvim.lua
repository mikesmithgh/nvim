return {
  'mikesmithgh/borderline.nvim',
  priority = 5000,
  enabled = true,
  lazy = false,
  init = function()
    require('borderline').setup({
      border = 'thinblock',
    })
  end,
}
