return {
  'windwp/nvim-autopairs',
  enabled = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    require('nvim-autopairs').setup()
  end,
}
