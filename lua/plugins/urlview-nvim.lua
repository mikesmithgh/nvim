return {
  'axieax/urlview.nvim',
  config = function()
    require('urlview').setup({
      -- custom configuration options --
      default_picker = 'telescope',
      default_action = 'clipboard',
      default_title = 'urlview.nvim',
    })
  end,
}
