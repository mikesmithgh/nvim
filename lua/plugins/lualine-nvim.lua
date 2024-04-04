return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  -- cond = not vim.g.is_kitty_scrollback_pager,
  dependencies = { 'nvim-tree/nvim-web-devicons', 'mikesmithgh/gruvsquirrel.nvim' },
  event = 'User IntroDone',
  config = function()
    local ls = vim.o.laststatus
    local status, lualine = pcall(require, 'lualine')
    if not status then
      return true
    end
    local noice
    status, noice = pcall(require, 'noice')
    local noice_status = { 'filetype' }
    if status then
      noice_status = {
        {
          noice.api.status.command.get,
          cond = require('noice').api.status.command.has,
        },
        {
          noice.api.status.mode.get,
          cond = require('noice').api.status.mode.has,
          color = { fg = '#dbbc5f' },
        },
        { 'filetype' },
      }
    end

    local set_git_prompt_string_lualine = function()
      lualine.git_prompt_string = vim.system({ 'git-prompt-string', '--prompt-prefix=', '--json' }):wait().stdout
      local git_prompt_string_json = vim.json.decode(lualine.git_prompt_string)
      local colors = {}
      if git_prompt_string_json.fgColor and git_prompt_string_json.fgColor ~= '' then
        colors.fg = git_prompt_string_json.fgColor
      end
      if git_prompt_string_json.bgColor and git_prompt_string_json.bgColor ~= '' then
        colors.bg = git_prompt_string_json.bgColor
      end
      lualine.git_prompt_string_color = colors
      lualine.git_prompt_string_status = git_prompt_string_json.promptPrefix
        .. git_prompt_string_json.branchInfo
        .. git_prompt_string_json.branchStatus
        .. git_prompt_string_json.promptSuffix
    end

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'BufWritePost', 'FocusGained', 'FocusLost' }, {
      group = vim.api.nvim_create_augroup('GitPromptStringCursorHold', { clear = true }),
      pattern = '*',
      callback = set_git_prompt_string_lualine,
    })
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      group = vim.api.nvim_create_augroup('GitPromptStringBufEnter', { clear = true }),
      pattern = '*',
      callback = function()
        set_git_prompt_string_lualine()
        return true
      end,
    })
    vim.api.nvim_create_autocmd({ 'User' }, {
      group = vim.api.nvim_create_augroup('GitPromptStringFugitive', { clear = true }),
      pattern = 'FugitiveChanged',
      callback = function()
        set_git_prompt_string_lualine()
      end,
    })

    local git_prompt_string_section = {
      {
        icon = '',
        function()
          return lualine.git_prompt_string_status or ''
        end,
        color = function()
          return lualine.git_prompt_string_color or ''
        end,
      },
    }

    lualine.setup({
      options = {
        icons_enabled = true,
        -- theme = 'gruvsquirrel',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        -- lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_b = { 'filename' },
        lualine_c = git_prompt_string_section,
        -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_x = noice_status,
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
      tabline = {
        -- lualine_a = {'buffers'},
        -- lualine_b = {},
        -- lualine_c = {},
        -- lualine_x = {},
        -- lualine_y = {},
        -- lualine_z = {'tabs'}
      },
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })

    vim.o.laststatus = ls
    return true -- return true to delete the autocommand
  end,
}
