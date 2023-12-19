return {
  {
    'mikesmithgh/gruvsquirrel.nvim',
    priority = 1000,
    enabled = true,
    lazy = false,
    dev = true,
    config = function()
      -- load colorscheme on startup
      vim.cmd([[colorscheme gruvsquirrel]])
    end,
  },
}
