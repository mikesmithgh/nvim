return {
  'windwp/nvim-autopairs',
  enabled = false,
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    require('nvim-autopairs').setup()
  end,
}
