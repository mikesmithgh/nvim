vim.g.mapleader = ' '
vim.g.maplocalleader = ','
-- vim.api.nvim_create_autocmd({ 'FileType' }, {
--   pattern = { 'kitty-scrollback' },
--   callback = vim.schedule_wrap(function(ev)
--     local res = { '' }
--     for k, v in pairs(ev) do
--       res[#res + 1] = tostring(k) .. ' = ' .. tostring(v)
--     end
--     local bufid = vim.api.nvim_create_buf(false, true)
--     local winid = vim.api.nvim_open_win(bufid, true, {
--       relative = 'cursor',
--       zindex = 40,
--       focusable = false,
--       height = #res + 1,
--       width = 50,
--       row = 0,
--       col = 0,
--       border = 'rounded',
--     })
--     vim.api.nvim_buf_set_lines(bufid, 0, -1, false, res)
--     vim.api.nvim_set_option_value('winhighlight', 'NormalFloat:KittyScrollbackNvimNormal', {
--       win = winid,
--     })
--   end),
-- })
vim.opt.runtimepath:append('/Users/mike/gitrepos/kitty-scrollback.nvim')
-- vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/kitty-scrollback.nvim')
require('kitty-scrollback').setup({
  global = function()
    return {
      status_window = {
        icons = {
          nvim = '',
        },
      },
    }
  end,
})
