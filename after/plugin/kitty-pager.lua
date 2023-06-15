local function size(max, value)
  return value > 1 and math.min(value, max) or math.floor(max * value)
end

local function scrollback_msg()
  local buffer_id = vim.api.nvim_create_buf(false, true)
  local window_id = vim.api.nvim_open_win(buffer_id, false, {
    relative = 'editor',
    noautocmd = true,
    zindex = 1000,
    style = 'minimal',
    focusable = false,
    width = size(vim.o.columns, 28),
    height = 1,
    row = 0,
    col = vim.o.columns,
    border = 'none',
    -- border = require('style').border.outer_thin,
  })

  -- float window with warning highlighting
  local render_timer_ns = vim.api.nvim_create_namespace('render_timer')
  vim.api.nvim_win_set_hl_ns(window_id, render_timer_ns)
  local normal_float_hl = vim.api.nvim_get_hl(0, { name = 'NormalFloat' })
  local comment_hl = vim.api.nvim_get_hl(0, { name = 'WarningMsg' })
  local timer_hl = vim.tbl_extend('force', normal_float_hl, comment_hl)
  vim.api.nvim_set_hl(render_timer_ns, 'Normal', timer_hl)
  vim.api.nvim_buf_set_lines(buffer_id, 0, 0, false, { '           󰄛   ' })
  -- vim.defer_fn(function()
  --   vim.api.nvim_buf_delete(buffer_id, { force = true })
  -- end, 5000)
end

vim.api.nvim_create_augroup('KittyLess', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = 'KittyLess',
  pattern = { '*' },
  callback = function()
    if vim.g.is_kitty_scrollback_pager then
      vim.cmd('BaleiaLess')
      scrollback_msg()
    end
    return true
  end,
})
