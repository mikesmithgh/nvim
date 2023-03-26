return {
  'jose-elias-alvarez/null-ls.nvim',
  config = function()
    local status, null_ls = pcall(require, 'null-ls')
    if not status then
      return
    end
    null_ls.setup({
      sources = {
        -- null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.completion.luasnip,
        -- null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports,
        -- null_ls.builtins.formatting.stylua, -- using builtin from sumneko
        -- null_ls.builtins.formatting.black,
      },
    })
  end,
}
