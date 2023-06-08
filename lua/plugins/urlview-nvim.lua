return {
  'axieax/urlview.nvim',
  config = function()
    require('urlview').setup({
      -- custom configuration options --
      default_picker = 'telescope',
    })
  end,
}
