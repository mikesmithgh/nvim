return {
  'hrsh7th/cmp-cmdline',
  enabled = true,
  lazy = false,
  dependencies = {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require('cmp')
    local cmp_api = require('cmp.utils.api')
    local select_opts = { behavior = cmp.SelectBehavior.Insert }

    cmp.event:on('menu_opened', function(menu)
      if cmp_api.is_cmdline_mode() then
        cmp.core.view.custom_entries_view:_select(0, select_opts)
      end
    end)

    local mappings = {
      ['<C-z>'] = {
        c = function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end,
      },
      ['<Tab>'] = {
        c = function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end,
      },
      ['<S-Tab>'] = {
        c = function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end,
      },
      ['<C-e>'] = {
        c = cmp.mapping.abort(),
      },
      ['<C-y>'] = {
        c = cmp.mapping.confirm({ select = false }),
      },
      ['<CR>'] = {
        c = function(fallback)
          cmp.mapping.confirm({ select = true })
          fallback()
        end
      },
      ['<Down>'] = {
        c = function(fallback)
          if cmp.visible() then
            cmp.select_next_item(select_opts)
          else
            fallback()
          end
        end,
      },
      ['<Up>'] = {
        c = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(select_opts)
          else
            fallback()
          end
        end,
      },
      ['<Esc>'] = {
        c = function()
          local cmp_is_visible = cmp.core.view:visible()
          local leave_cmd_mode = not cmp_is_visible
          if cmp_is_visible then
            local e = cmp.core.view:get_selected_entry()
            local is_active = cmp.core.view.custom_entries_view.active
            leave_cmd_mode = e == nil or not is_active
            if not leave_cmd_mode then
              cmp.core.view.custom_entries_view:_select(0, select_opts)
            end
          end
          if leave_cmd_mode then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'c', true)
          end
        end
      },
      ['<C-j>'] = {
        c = function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ count = 5, })
          else
            fallback()
          end
        end,
      },
      ['<C-k>'] = {
        c = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ count = 5, })
          else
            fallback()
          end
        end,
      },
    }
    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      view = {
        entries = 'custom',
      },
      mapping = mappings,
      sources = {
        { name = 'buffer' },
      },
    })
    -- `?` cmdline setup.
    cmp.setup.cmdline('?', {
      view = {
        entries = 'custom',
      },
      mapping = mappings,
      sources = {
        { name = 'buffer' },
      },
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      view = {
        entries = 'custom',
      },
      mapping = mappings,
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
          },
        },
      }),
    })
  end,
}
