return {
  'akinsho/toggleterm.nvim',
  version = '2.*',
  enabled = true,
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
