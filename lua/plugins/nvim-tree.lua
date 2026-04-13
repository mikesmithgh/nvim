return {
  'nvim-tree/nvim-tree.lua',
  enabled = true,
  lazy = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  event = 'VeryLazy',
  cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeFocus' },
  config = function()
    require('nvim-tree').setup()
  end,
}
