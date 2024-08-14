return {
  '3rd/image.nvim',
  cond = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  ft = { 'norg', 'markdown' },
  lazy = true,
  enabled = true,
  config = true,
  dependencies = { 'vhrro/luarocks.nvim' },
}
