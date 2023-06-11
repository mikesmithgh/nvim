return {
  'jose-elias-alvarez/null-ls.nvim',
  enabled = true,
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      border = require('style').border.outer_thin,
      sources = {
        null_ls.builtins.formatting.shfmt.with({
          extra_args = { '--case-indent', '--simplify', '--binary-next-line', '--indent', '2' },
        }),
        -- null_ls.builtins.code_actions.shellcheck,
        -- null_ls.builtins.completion.luasnip,
        -- null_ls.builtins.formatting.gofmt,
        -- null_ls.builtins.formatting.gofumpt,
        -- null_ls.builtins.formatting.goimports,
      },
    })
  end,
}
