return {
  'romgrk/barbar.nvim',
  enabled = true and not vim.g.is_kitty_scrollback_pager,
  dependencies = 'nvim-web-devicons',
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  config = function()
    require('barbar').setup({
      hide = { extensions = false, inactive = false },
      insert_at_end = true,
      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        NvimTree = { text = 'NvimTree' },
        -- Or, specify the text used for the offset:
        undotree = { text = 'Undotree' },
        dapui_watches = { text = 'DAP UI' },
        -- Or, specify the event which the sidebar executes when leaving:
        ['neo-tree'] = { text = 'Neo-tree' },
      },
      icons = {
        button = '×',
        separator = { left = '▎', right = '' },
        -- filetype = { custom_colors = true },
        -- buffer_number = true,
        -- current = { buffer_index = true },
        -- inactive = { button = '×' },
        -- visible = { modified = { buffer_number = false } },
      },
    })
  end,
}
