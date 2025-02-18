return {
  '3rd/image.nvim',
  cond = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  ft = { 'norg' },
  lazy = true,
  enabled = false,
  config = true,
  dependencies = { 'vhrro/luarocks.nvim' },
}
