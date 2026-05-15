return {
  'dlyongemallo/diffview.nvim', -- active fork of sindrets/diffview.nvim
  lazy = true,
  cmd = {
    'DiffviewOpen',
    'DiffviewToggle',
    'DiffviewDiffFiles',
    'DiffviewFileHistory',
    'DiffviewClose',
    'DiffviewFocusFiles',
    'DiffviewToggleFiles',
    'DiffviewRefresh',
    'DiffviewLog',
  },
  enabled = true,
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('diffview').setup()
  end,
}
