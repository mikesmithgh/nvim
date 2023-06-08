return {
  'folke/noice.nvim',
  enabled = true,
  lazy = false,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
    'norcalli/nvim-colorizer.lua',
  },
  config = function()
    require('noice').setup({
      cmdline = {
        view = 'cmdline',
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true, -- enables the Noice messages UI
        view = 'notify', -- default view for messages
        view_error = 'notify', -- view for errors
        view_warn = 'notify', -- view for warnings
        view_history = 'messages', -- view for :messages
        view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
      },
      -- format = {
      --   notify = { "{message}", "{message}" },
      -- },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
      },
      routes = {
        {
          filter = {
            event = 'notify',
            warning = true,
            find = 'To execute the command you must write the buffer contents.',
          },
          view = 'mini',
        },
        -- {
        --   filter = {
        --     event = 'notify',
        --     warning = true,
        --     find = 'scrollback.nvim',
        --   },
        --   view = 'mini',
        -- },
        {
          view = 'hover',
          opts = {
            border = {
              style = require('style').border.outer_thin,
            },
            position = { row = 2, col = 2 },
          },
          filter = { event = 'lsp', kind = 'signature' },
        },
        {
          view = 'hover',
          opts = {
            border = {
              style = require('style').border.outer_thin,
            },
            position = { row = 2, col = 2 },
          },
          filter = { event = 'lsp', kind = 'hover' },
        },
      },
    })

    -- local Config = require('noice.config')
    -- local after_noice_load = function()
    --   if Config._running then
    --     vim.schedule(function()
    --       local stylize_markdown_fn = vim.lsp.util.stylize_markdown
    --       vim.lsp.util.stylize_markdown = function(buf, contents, _opts)
    --         stylize_markdown_fn(buf, contents, _opts)
    --         require('colorizer').attach_to_buffer(buf)
    --       end
    --     end)
    --   else
    --     vim.schedule(after_lazy_load)
    --   end
    -- end
    -- vim.schedule(after_noice_load)
  end,
}
