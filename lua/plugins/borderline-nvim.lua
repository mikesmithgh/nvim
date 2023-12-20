return {
  'mikesmithgh/borderline.nvim',
  enabled = true,
  lazy = true,
  event = { 'User IntroDone' },
  cmd = {
    'Borderline',
    'BorderlineDev',
    'BorderlineInfo',
    'BorderlineNext',
    'BorderlinePrevious',
    'BorderlineRegister',
    'BorderlineDeregister',
    'BorderlineStopNextTimer',
    'BorderlineStartNextTimer',
  },
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
