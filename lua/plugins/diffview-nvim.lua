return {
  'sindrets/diffview.nvim',
  lazy = true,
  cmd = {
    'DiffviewLog',
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggle',
    'DiffviewRefresh',
    'DiffviewFocusFiles',
    'DiffviewFileHistory',
    'DiffviewToggleFiles',
  },
  enabled = true,
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('diffview').setup()
  end,
}
