local style = require('style')
local opts = {
  prompt_prefix = '$ ',
  selection_caret = '󰅂 ',
  entry_prefix = '  ',
  multi_icon = '﹢',
  -- border = true,
  -- borderchars = {
  --   prompt = style.telescope_fmt(style.border.thinblock_nobottom),
  --   results = style.telescope_fmt(style.border.thinblock_notop),
  --   preview = style.telescope_fmt(style.border.thinblock),
  -- },
  sorting_strategy = 'ascending', -- display results top->bottom
  layout_config = {
    prompt_position = 'top',
    preview_width = 0.6,
  },
}
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup({
      defaults = opts,
      -- defaults = require('telescope.themes').get_dropdown(opts)
      -- defaults = require('telescope.themes').get_cursor(opts)
      -- defaults = require('telescope.themes').get_ivy(opts)
    })
  end,
}
