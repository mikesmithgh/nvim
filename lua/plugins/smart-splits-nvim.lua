return
{
  'mrjones2014/smart-splits.nvim',
  build = './kitty/install-kittens.bash',
  config = function()
    require('smart-splits').setup({
      default_amount = 5,
    })
  end,
}
