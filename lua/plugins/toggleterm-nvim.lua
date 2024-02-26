return {
  'akinsho/toggleterm.nvim',
  version = '2.*',
  enabled = true,
  lazy = true,
  cmd = {
    'ToggleTerm',
    'ToggleTermSetName',
    'ToggleTermToggleAll',
    'ToggleTermSendCurrentLine',
    'ToggleTermSendVisualLines',
    'ToggleTermSendVisualSelection',
  },
  config = function()
    local status, toggleterm = pcall(require, 'toggleterm')
    if not status then
      return
    end
    toggleterm.setup({
      hide_numbers = true,
      start_in_insert = true,
      persist_mode = false,
    })
  end,
}
