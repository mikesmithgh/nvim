-- HACK: add padding to window, overriding fix_layout to offset the window
local function hack_fix_layout_with_padding(padding)
  local M = require('zen-mode.view')
  M.fix_layout = function(win_resized)
    if M.is_open() then
      if win_resized then
        local l = M.layout(M.opts)
        vim.api.nvim_win_set_config(M.win, { width = l.width, height = l.height })
        vim.api.nvim_win_set_config(M.bg_win, { width = vim.o.columns, height = M.height() })
      end
      local height = vim.api.nvim_win_get_height(M.win)
      local width = vim.api.nvim_win_get_width(M.win)
      local actual_padding = vim.o.columns > 200 and padding or 0
      local col = M.round((vim.o.columns - width) / 2) + actual_padding -- HACK: add padding to window
      local row = M.round((M.height() - height) / 2)
      local cfg = vim.api.nvim_win_get_config(M.win)
      -- HACK: col is an array?
      local wcol = type(cfg.col) == 'number' and cfg.col or cfg.col[false]
      local wrow = type(cfg.row) == 'number' and cfg.row or cfg.row[false]
      if wrow ~= row or wcol ~= col then
        vim.api.nvim_win_set_config(M.win, { col = col, row = row, relative = 'editor' })
      end
    end
  end
end

return {
  'folke/zen-mode.nvim',
  enabled = true,
  cmd = 'ZenMode',
  config = function()
    hack_fix_layout_with_padding(49)
    require('zen-mode').setup({
      on_open = function()
        local ok, incline = pcall(require, 'incline')
        if ok then
          vim.defer_fn(incline.disable, 100)
        end
      end,
      on_close = function()
        local ok, incline = pcall(require, 'incline')
        if ok then
          vim.defer_fn(incline.enable, 100)
        end
      end,
      window = {
        backdrop = 1,
        width = 190,
        height = 1,
      },
    })
  end,
}
