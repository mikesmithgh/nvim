return {
  {
    'nvim-neorg/neorg',
    enabled = true,
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = '*', -- Pin Neorg to the latest stable release
    dependencies = 'mpeterv/hererocks',
    config = function()
      -- see https://github.com/nvim-neorg/neorg/issues/1808#issuecomment-4281328564
      vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy-rocks/tree-sitter-norg/lib/lua/5.1')
      vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy-rocks/tree-sitter-norg-meta/lib/lua/5.1')
      require('neorg').setup({
        load = {
          ['core.defaults'] = {}, -- Loads default behaviour
          ['core.dirman'] = { -- Manages Neorg workspaces
            config = {
              default_workspace = 'notes',
              workspaces = {
                notes = '~/neorg/notes',
              },
              index = 'index.norg', -- The name of the main (root) .norg file
              use_popup = true,
            },
          },
          ['core.summary'] = {},
          ['core.concealer'] = {
            config = {
              icons = {
                todo = {
                  pending = {
                    icon = '',
                  },
                },
              },
            },
          },
          ['core.itero'] = {}, -- <M-CR> to add header/list items
          ['core.promo'] = {}, -- promotes/demotes headers, etc
          ['core.qol.toc'] = {},
          ['core.qol.todo_items'] = {},
          ['core.export'] = {},
          -- https://github.com/nvim-neorg/neorg/wiki/Metagen
          ['core.esupports.metagen'] = {},
        },
      })
    end,
  },
}
