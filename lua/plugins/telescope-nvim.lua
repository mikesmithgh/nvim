local opts = {
  prompt_prefix = '$ ',
  selection_caret = '󰅂 ',
  entry_prefix = '  ',
  multi_icon = '﹢',
  -- border = true,
  sorting_strategy = 'ascending', -- display results top->bottom
  layout_config = {
    prompt_position = 'top',
    preview_width = 0.6,
  },
}
return {
  'nvim-telescope/telescope.nvim',
  enabled = true,
  lazy = true,
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  event = 'VeryLazy',
  cmd = 'Telescope',
  config = function()
    require('telescope').setup({
      defaults = opts,
      -- defaults = require('telescope.themes').get_dropdown(opts)
      -- defaults = require('telescope.themes').get_cursor(opts)
      -- defaults = require('telescope.themes').get_ivy(opts)
    })
  end,
}
