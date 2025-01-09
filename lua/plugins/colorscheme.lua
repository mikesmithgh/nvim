return {
  {
    'mikesmithgh/gruvsquirrel.nvim',
    priority = 1000,
    enabled = true,
    lazy = false,
    dev = true,
    opts = {
      cache = true,
    },
    build = function()
      require('gruvsquirrel.cache').clear()
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    enabled = false,
    lazy = false,
    opts = {},
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    enabled = false,
    lazy = false,
    opts = {},
  },
}
