return {
  'smjonas/inc-rename.nvim',
  enabled = true,
  lazy = true,
  event = { 'CmdlineEnter' },
  config = function()
    require('inc_rename').setup()
  end,
}
