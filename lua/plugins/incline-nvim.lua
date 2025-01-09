return {
  'b0o/incline.nvim',
  enabled = true,
  lazy = true,
  event = 'User AfterIntro',
  config = function()
    local ok, incline = pcall(require, 'gruvsquirrel.plugins.incline-nvim')
    if not ok then
      incline = require('incline')
    end
    incline.setup()
  end,
}
