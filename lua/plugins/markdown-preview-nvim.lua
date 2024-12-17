-- install without yarn or npm
return {
  'iamcco/markdown-preview.nvim',
  enabled = true,
  lazy = true,
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = {
    'markdown',
  },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
}
