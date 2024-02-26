return {
  'hrsh7th/cmp-cmdline',
  enabled = true,
  lazy = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require('cmp')
    local cmp_api = require('cmp.utils.api')
    local select_opts = { behavior = cmp.SelectBehavior.Insert }

    cmp.event:on('menu_opened', function()
      if cmp_api.is_cmdline_mode() then
        ---@diagnostic disable-next-line: invisible
        cmp.core.view.custom_entries_view:_select(0, select_opts)
      end
    end)

    local common_mappings = {
      ['<Tab>'] = {
        c = function()
          local fn = cmp.mapping.complete()
          if cmp.visible() then
            fn = cmp.mapping.select_next_item(select_opts)
          end
          fn()
        end,
      },
      ['<S-Tab>'] = {
        c = function()
          local fn = cmp.mapping.complete()
          if cmp.visible() then
            fn = cmp.mapping.select_prev_item(select_opts)
          end
          fn()
        end,
      },
      ['<C-e>'] = {
        c = function(fallback)
          local fn = fallback
          if cmp.visible() then
            fn = cmp.mapping.abort()
          end
          fn()
        end,
      },
      ['<C-y>'] = {
        c = function(fallback)
          local fn = fallback
          if cmp.visible() then
            fn = cmp.mapping.confirm({ select = false })
          end
          fn()
        end,
      },
      ['<Down>'] = {
        c = function()
          local fn = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Down>', true, false, true), 'n', true)
          end
          if cmp.visible() then
            fn = cmp.mapping.select_next_item(select_opts)
          end
          fn()
        end,
      },
      ['<Up>'] = {
        c = function()
          local fn = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Up>', true, false, true), 'n', true)
          end
          if cmp.visible() then
            fn = cmp.mapping.select_prev_item(select_opts)
          end
          fn()
        end,
      },
      ['<Esc>'] = {
        c = function()
          -- do not use fallback, it executes the command we want to cancel
          local fn = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', true)
          end
          if cmp.visible() then
            fn = cmp.mapping.abort()
          end
          fn()
        end,
      },
      ['<C-j>'] = {
        c = function(fallback)
          local fn = fallback
          if cmp.visible() then
            fn = cmp.mapping.select_next_item(vim.tbl_extend('force', select_opts, { count = 5 }))
          end
          fn()
        end,
      },
      ['<C-k>'] = {
        c = function(fallback)
          local fn = fallback
          if cmp.visible() then
            fn = cmp.mapping.select_prev_item(vim.tbl_extend('force', select_opts, { count = 5 }))
          end
          fn()
        end,
      },
      ['<C-f>'] = {
        c = function(fallback)
          local fn = fallback
          if cmp.visible() then
            fn = function()
              local close = cmp.mapping.close()
              close()
              fallback()
            end
          end
          fn()
        end,
      },
    }

    local cmd_mappings = {
      ['<C-a>'] = {
        c = function()
          -- move to start of line
          local move_to_start_of_line = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-b>', true, false, true), 'n', true)
          end
          local fn = move_to_start_of_line
          if cmp.visible() then
            fn = function()
              local confirm = cmp.mapping.confirm({ select = false })
              confirm()
              move_to_start_of_line()
            end
          end
          fn()
        end,
      },
      ['<CR>'] = {
        c = function()
          local expand_and_execute = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-]>', true, false, true), 'n', true)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', true)
          end
          local fn = expand_and_execute
          if cmp.visible() then
            fn = function()
              local confirm = cmp.mapping.confirm({ select = true })
              confirm() -- select entry
              expand_and_execute()
            end
          end
          fn()
        end,
      },
    }

    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      completion = {
        autocomplete = false,
      },
      view = {
        entries = 'custom',
      },
      mapping = common_mappings,
      sources = {
        { name = 'buffer' },
      },
    })
    -- `?` cmdline setup.
    cmp.setup.cmdline('?', {
      completion = {
        autocomplete = false,
      },
      view = {
        entries = 'custom',
      },
      mapping = common_mappings,
      sources = {
        { name = 'buffer' },
      },
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      ---@diagnostic disable-next-line: missing-fields
      completion = {
        autocomplete = false,
      },
      view = {
        entries = 'custom',
      },
      mapping = vim.tbl_extend('force', common_mappings, cmd_mappings),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        {
          name = 'cmdline',
          autocomplete = false,
          option = {
            ignore_cmds = {
              'Man',
              '!',
              'naw',
            },
          },
        },
      }),
    })
  end,
}
