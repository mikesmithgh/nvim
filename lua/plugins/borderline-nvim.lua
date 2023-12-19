return {
  'mikesmithgh/borderline.nvim',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('borderline').setup({
      border = 'thinblock',
      enabled = true,
      dev_mode = true,
      border_styles = {
        error = {
          { '┌', 'NvimInternalError' },
          { '─', 'NvimInternalError' },
          { '┐', 'NvimInternalError' },
          { '│', 'NvimInternalError' },
          { '┘', 'NvimInternalError' },
          { '─', 'NvimInternalError' },
          { '└', 'NvimInternalError' },
          { '│', 'NvimInternalError' },
        },
      },
    })
  end,
}
