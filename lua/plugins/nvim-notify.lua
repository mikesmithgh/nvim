return {
  'rcarriga/nvim-notify',
  enabled = true,
  config = function()
    local stages = require('notify.stages.slide')('top_down')
    local notify = require('notify')

    notify.setup({
      render = 'compact',
      stages = {
        -- reference: https://github.com/rcarriga/nvim-notify/issues/182
        function(...)
          local opts = stages[1](...)
          if opts then
            opts.border = 'none'
            opts.row = opts.row + 1
          end
          return opts
        end,
        unpack(stages, 2),
      },
      timeout = 2000,
    })
  end,
}
