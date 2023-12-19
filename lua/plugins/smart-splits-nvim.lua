return {
  'mrjones2014/smart-splits.nvim',
  build = './kitty/install-kittens.bash',
  enabled = true,
  config = function()
    require('smart-splits').setup({
      default_amount = 5,
    })
  end,
}
