return {
  'stevearc/conform.nvim',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    local conform = require('conform')
    conform.setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        go = { 'goimports', 'gofumpt' },
        fish = { 'fish_indent' },
      },
      -- If this is set, Conform will run the formatter on save.
      -- It will pass the table to conform.format().
      -- This can also be a function that returns the table.
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_fallback = true,
        timeout_ms = 500,
      },
    })
    conform.formatters.shfmt = {
      prepend_args = { '--indent', '2' },
    }
    -- The conform formatexpr should fall back to LSP when no formatters are
    -- available, and fall back to the internal default if no LSP clients are
    -- available. So it should be safe to set it globally.
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
