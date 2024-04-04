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
        -- {
        --   require("noice").api.status.message.get_hl,
        --   cond = require("noice").api.status.message.has,
        -- },
        {
          noice.api.status.command.get,
          cond = require('noice').api.status.command.has,
        },
        {
          noice.api.status.mode.get,
          cond = require('noice').api.status.mode.has,
          color = { fg = '#dbbc5f' },
        },
        -- {
        --   require("noice").api.status.search.get,
        --   cond = require("noice").api.status.search.has,
        --   color = { fg = "#dbbc5f" },
        -- },
        { 'filetype' },
      }
    end

    local git_prompt_string = function()
      return vim.system({ 'git-prompt-string', '--prompt-prefix= ', '--json' }):wait().stdout
    end
    local git_prompt_string_status = function()
      if not lualine.git_prompt_string then
        lualine.git_prompt_string = git_prompt_string()
      elseif not lualine.git_prompt_string_timer then
        lualine.git_prompt_string_timer = vim.defer_fn(function()
          lualine.git_prompt_string = git_prompt_string()
          lualine.git_prompt_string_timer = nil
        end, 1000)
      end

      local git_prompt_string_json = vim.json.decode(lualine.git_prompt_string)
      local colors = {}
      if git_prompt_string_json.fgColor and git_prompt_string_json.fgColor ~= '' then
        colors.fg = git_prompt_string_json.fgColor
      end
      if git_prompt_string_json.bgColor and git_prompt_string_json.bgColor ~= '' then
        colors.bg = git_prompt_string_json.bgColor
      end
      lualine.git_prompt_string_color = colors
      return git_prompt_string_json.promptPrefix
        .. git_prompt_string_json.branchInfo
        .. git_prompt_string_json.branchStatus
        .. git_prompt_string_json.promptSuffix
    end

    local git_prompt_string_section = {
      {
        git_prompt_string_status,
        color = function()
          return lualine.git_prompt_string_color
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
