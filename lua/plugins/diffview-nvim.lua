return {
  'sindrets/diffview.nvim',
  -- 'mikesmithgh/diffview.nvim',
  -- branch = 'fix-islist', -- see https://github.com/sindrets/diffview.nvim/pull/489
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
