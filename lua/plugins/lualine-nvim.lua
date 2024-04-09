return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  -- cond = not vim.g.is_kitty_scrollback_pager,
  dependencies = { 'nvim-tree/nvim-web-devicons', 'mikesmithgh/gruvsquirrel.nvim' },
  event = 'User IntroDone',
  config = function()
    -- b section
    local relative_cwd = function()
      return vim.uv.cwd():gsub(vim.env.HOME, '~')
    end
    local cwd = relative_cwd()
    vim.api.nvim_create_autocmd({ 'DirChanged' }, {
      group = vim.api.nvim_create_augroup('LualineDirSection', { clear = true }),
      callback = function()
        cwd = relative_cwd()
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
      end,
    })
    local x = {
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
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true, -- sets laststatus = 3
        refresh = {
          statusline = 5000,
          tabline = 5000,
          winbar = 5000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = b,
        lualine_c = { 'git-prompt-string' },
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
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
