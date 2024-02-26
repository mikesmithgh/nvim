return {
  'mrjones2014/smart-splits.nvim',
  build = './kitty/install-kittens.bash',
  enabled = true,
  lazy = false,
  keys = {
    { '<C-w>h' },
    { '<C-w>j' },
    { '<C-w>k' },
    { '<C-w>l' },
    { '<A-Left>' },
    { '<A-Down>' },
    { '<A-Up>' },
    { '<A-Right>' },
  },
  config = function()
    require('smart-splits').setup({
      default_amount = 5,
    })
  end,
}
