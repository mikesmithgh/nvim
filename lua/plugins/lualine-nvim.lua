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
    local git_prompt_string_section = {
      icon = '',
      function()
        return lualine.git_prompt_string_status or ''
      end,
      color = function()
        return lualine.git_prompt_string_color or {}
      end,
    }

    vim.api.nvim_set_hl(0, 'GitPromptStringClean', {
      -- fg = 'DarkGreen',
      fg = '#8faa80',
      bg = '#1a1a1a',
      default = true,
    })
    vim.api.nvim_set_hl(0, 'GitPromptStringDelta', {
      -- fg = 'DarkYellow',
      fg = '#dbbc5f',
      bg = '#1a1a1a',
      default = true,
    })
    vim.api.nvim_set_hl(0, 'GitPromptStringDirty', {
      -- fg = 'DarkRed',
      fg = '#ff6961',
      bg = '#1a1a1a',
      default = true,
    })
    vim.api.nvim_set_hl(0, 'GitPromptStringUntracked', {
      -- fg = 'DarkMagenta',
      fg = '#d3869b',
      bg = '#1a1a1a',
      default = true,
    })
    vim.api.nvim_set_hl(0, 'GitPromptStringNoUpstream', {
      -- fg = 'DarkGray',
      fg = '#968c81',
      bg = '#1a1a1a',
      default = true,
    })
    vim.api.nvim_set_hl(0, 'GitPromptStringMerging', {
      -- fg = 'DarkBlue',
      fg = '#83a598',
      bg = '#1a1a1a',
      default = true,
    })
    local set_git_prompt_string_lualine = function()
      lualine.git_prompt_string = vim
        .system({
          'git-prompt-string',
          '--json',
          '--prompt-prefix=',
          '--color-clean=GitPromptStringClean',
          '--color-delta=GitPromptStringDelta',
          '--color-dirty=GitPromptStringDirty',
          '--color-untracked=GitPromptStringUntracked',
          '--color-no-upstream=GitPromptStringNoUpstream',
          '--color-merging=GitPromptStringMerging',
        })
        :wait().stdout
      if lualine.git_prompt_string == '' then
        lualine.git_prompt_string_color = nil
        lualine.git_prompt_string_status = nil
        return
      end
      local git_prompt_string_json = vim.json.decode(lualine.git_prompt_string)
      local color = ''
      if git_prompt_string_json.color and git_prompt_string_json.color ~= '' then
        color = git_prompt_string_json.color
      end
      lualine.git_prompt_string_color = color
      lualine.git_prompt_string_status = git_prompt_string_json.promptPrefix
        .. git_prompt_string_json.branchInfo
        .. git_prompt_string_json.branchStatus
        .. git_prompt_string_json.promptSuffix
    end

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'BufWritePost', 'FocusGained', 'FocusLost', 'DirChanged', 'TermLeave' }, {
      group = vim.api.nvim_create_augroup('GitPromptStringCursorHold', { clear = true }),
      pattern = '*',
      callback = set_git_prompt_string_lualine,
    })
    vim.api.nvim_create_autocmd({ 'User' }, {
      group = vim.api.nvim_create_augroup('GitPromptStringUser', { clear = true }),
      pattern = { 'FugitiveChanged', 'VeryLazy', 'IntroDone' },
      callback = set_git_prompt_string_lualine,
    })

    set_git_prompt_string_lualine()

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
        lualine_b = {
          {
            function()
              return vim.uv.cwd():gsub(vim.env.HOME, '~')
            end,
          },
        },
        lualine_c = { git_prompt_string_section },
        lualine_x = {
          {
            require('noice').api.status.command.get, ---@diagnostic disable-line: undefined-field
            cond = require('noice').api.status.command.has, ---@diagnostic disable-line: undefined-field
          },
          {
            require('noice').api.status.mode.get, ---@diagnostic disable-line: undefined-field
            cond = require('noice').api.status.mode.has, ---@diagnostic disable-line: undefined-field
            color = { fg = '#d6991d' },
          },
          { 'filetype' },
        },
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
