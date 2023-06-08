return {
  'danymat/neogen',
  enabled = true,
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('neogen').setup({
      enabled = true,
      snippet_engine = 'luasnip',
      input_after_comment = true,
    })
  end,
}
