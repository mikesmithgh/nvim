return {
  'sindrets/diffview.nvim',
  enabled = true,
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('diffview').setup({
      -- enhanced_diff_hl = true,
    })
  end
}
