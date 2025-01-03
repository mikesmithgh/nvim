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
    -- if you are having problems, try running $HOME/.local/share/nvim/lazy/markdown-preview.nvim/app/install.sh
    -- see https://github.com/iamcco/markdown-preview.nvim/issues/424#issuecomment-1033083561
    vim.fn['mkdp#util#install']()
  end,
}
