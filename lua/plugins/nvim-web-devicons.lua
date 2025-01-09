return {
  'nvim-tree/nvim-web-devicons',
  dev = false,
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    local ok, devicons = pcall(require, 'gruvsquirrel.plugins.nvim-web-devicons')
    if not ok then
      devicons = require('nvim-web-devicons')
    end
    devicons.setup()
  end,
}
