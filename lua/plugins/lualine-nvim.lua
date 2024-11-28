return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  cond = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'mikesmithgh/gruvsquirrel.nvim' },
  lazy = true,
  event = 'User AfterIntro',
  config = function()
    -- The events on which lualine redraws itself, this was removed from lualine in
    -- commit = '640260d'
    -- https://github.com/nvim-lualine/lualine.nvim/pull/1316
    -- however, I prefer autocmds over polling so I'm keeping it
    local default_refresh_events = {
      'WinEnter',
      'BufEnter',
      'BufWritePost',
      'SessionLoadPost',
      'FileChangedShellPost',
      'VimResized',
      'Filetype',
      'CursorMoved',
      'CursorMovedI',
      'ModeChanged',
    }
    vim.api.nvim_create_autocmd(default_refresh_events, {
      group = vim.api.nvim_create_augroup('LualineRefreshEvents', { clear = true }),
      callback = function()
        vim.schedule(function()
          require('lualine').refresh()
        end)
      end,
    })

    -- b section
    local relative_cwd = function()
      return vim.uv.cwd():gsub(vim.env.HOME, '~')
    end
    local cwd = relative_cwd()
    vim.api.nvim_create_autocmd({ 'DirChanged' }, {
      group = vim.api.nvim_create_augroup('LualineDirSection', { clear = true }),
      callback = function()
        cwd = relative_cwd()
        require('lualine').refresh()
      end,
    })
    local b = {
      {
        function()
          return cwd
        end,
      },
    }

    -- x section
    local rec_msg = ''
    vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
      group = vim.api.nvim_create_augroup('LualineRecordingSection', { clear = true }),
      callback = function(e)
        if e.event == 'RecordingLeave' then
          rec_msg = ''
        else
          rec_msg = 'recording @' .. vim.fn.reg_recording()
        end
        require('lualine').refresh()
      end,
    })
    local x = {
      -- see https://github.com/nvim-lualine/lualine.nvim/issues/868
      {
        ---@diagnostic disable-next-line: undefined-field
        require('noice').api.status.command.get,
        ---@diagnostic disable-next-line: undefined-field
        cond = require('noice').api.status.command.has,
      },
      {
        function()
          return rec_msg
        end,
        color = { fg = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'ModeMsg', link = false }).fg) },
      },
      { 'filetype' },
    }

    require('lualine').setup({
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        refresh = {
          statusline = 0, -- do not refresh on an interval
          tabline = 0,
          winbar = 0,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = b,
        lualine_c = { 'git_prompt_string' },
        lualine_x = x,
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
