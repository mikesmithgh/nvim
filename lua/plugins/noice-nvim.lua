return {
  'folke/noice.nvim',
  enabled = true,
  -- cond = vim.env.TERM ~= 'xterm-ghostty', -- see https://github.com/mitchellh/ghostty/issues/1054
  lazy = true,
  event = 'VeryLazy',
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
    local noiceconfig = require('noice.config')
    require('noice').setup({
      cmdline = {
        view = 'cmdline',
        format = vim.tbl_extend('force', noiceconfig.defaults().cmdline.format, {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = '^:', icon = '󰅂', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
          filter = { pattern = '^:%s*!', icon = '', lang = 'bash' },
          lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua', icon_hl_group = 'DevIconLua' },
          help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
          -- register <c-r> =
          calculator = { pattern = '^=', icon = '󰃬', lang = 'vimnormal' },
          input = {}, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
          increname = { pattern = '^:%s*IncRename%s+', icon = '󰑕', icon_hl_group = 'NoiceCmdlinePrompt' },
        }),
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
        lsp_doc_border = true, -- add a border to hover docs and signature help
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
      },
    })
  end,
}
