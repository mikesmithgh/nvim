-- TODO: causes start page issues
-- HACK: this is a hack
vim.api.nvim_create_augroup('Intro', { clear = true })
vim.api.nvim_create_autocmd(
  { 'CursorMoved', 'CursorMovedI', 'ModeChanged', 'InsertEnter', 'StdinReadPre' },
  {
    group = 'Intro',
    pattern = { '<buffer=1>' },
    callback = function()
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

      lualine.setup({
        options = {
          icons_enabled = true,
          theme = 'gruvsquirrel',
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
          lualine_b = { 'branch' },
          -- lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
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
      return true -- return true to delete the autocommand
    end,
  }
)

return {
  'nvim-lualine/lualine.nvim',
  enabled = true and not vim.g.is_kitty_scrollback_pager,
  dependencies = { 'nvim-tree/nvim-web-devicons', 'mikesmithgh/gruvsquirrel.nvim' },
}
