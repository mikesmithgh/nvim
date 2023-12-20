return {
  'folke/neodev.nvim',
  enabled = true,
  lazy = false,
  dependencies = {
    'neovim/nvim-lspconfig',
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    require('neodev').setup({
      library = { plugins = { 'nvim-dap-ui' }, types = true },
    })
  end,
}
