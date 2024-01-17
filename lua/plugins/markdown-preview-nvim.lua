-- install without yarn or npm
return {
  'iamcco/markdown-preview.nvim',
  enabled = true,
  lazy = true,
  cmd = {
    'MarkdownPreview',
    'MarkdownPreviewStop',
    'MarkdownPreviewToggle',
  },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
}
