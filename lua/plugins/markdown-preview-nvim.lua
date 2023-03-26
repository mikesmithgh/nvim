-- install without yarn or npm
return {
  'iamcco/markdown-preview.nvim',
  enabled = true,
  build = function()
    vim.fn['mkdp#util#install']()
  end,
}
