---Get all windows in the current tabpage that aren't NvimTree.
---@return table with valid win_ids
local function usable_win_ids()
  local full_name = require('nvim-tree.renderer.components.full-name')
  local view = require('nvim-tree.view')
  local config = require('nvim-tree.config')
  local tabpage = vim.api.nvim_get_current_tabpage()
  local win_ids = vim.api.nvim_tabpage_list_wins(tabpage)
  local tree_winid = view.get_winnr(tabpage)

  return vim.tbl_filter(function(id)
    local bufid = vim.api.nvim_win_get_buf(id)
    for option, v in pairs(config.g.actions.open_file.window_picker.exclude) do
      local ok, option_value = pcall(vim.api.nvim_get_option_value, option, { buf = bufid })

      if ok and vim.tbl_contains(v, option_value) then
        return false
      end
    end

    local win_config = vim.api.nvim_win_get_config(id)
    return id ~= tree_winid and id ~= full_name.popup_win and win_config.focusable and not win_config.hide and not win_config.external or false
  end, win_ids)
end

return {
  'nvim-tree/nvim-tree.lua',
  enabled = true,
  lazy = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  event = 'VeryLazy',
  cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeFocus' },
  config = function()
    require('nvim-tree').setup({
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        -- default mappings
        api.map.on_attach.default(bufnr)

        -- custom mappings
        -- I use 's' as my fzf leader, nvim-tree defaults this to open with system, lets remove this in favor of vim-like keybind gx
        vim.keymap.del('n', 's', { buffer = bufnr })
        vim.keymap.set('n', 'gx', api.node.run.system, opts('Run System'))
      end,
      hijack_netrw = false,
      renderer = {
        hidden_display = 'all',
      },
      actions = {
        open_file = {
          window_picker = {
            picker = function()
              -- logic copied from NvimTree with slight modification
              -- attempt to use last accessed window, otherwise fallback to NvimTree logic
              -- also respect excluded window types
              local usable_wins = usable_win_ids()
              local target_winid = vim.fn.win_getid(vim.fn.winnr('#'))
              -- first available usable window
              if not vim.tbl_contains(usable_wins, target_winid) then
                if #usable_wins > 0 then
                  target_winid = usable_wins[1]
                else
                  target_winid = -1
                end
              end
              return target_winid
            end,
          },
        },
      },
    })
  end,
}
