return {
  'romgrk/barbar.nvim',
  enabled = true and not vim.g.is_kitty_scrollback_pager,
  dependencies = 'nvim-web-devicons',
  hide = { extensions = false, inactive = false },
  config = function()
    require('barbar').setup({
      icons = {
        button = '×',
        -- filetype = { custom_colors = true },
        -- buffer_number = true,
        -- current = { buffer_index = true },
        -- inactive = { button = '×' },
        -- visible = { modified = { buffer_number = false } },
      },
    })
  end,
}
