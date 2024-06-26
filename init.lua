if vim.fn.has('nvim-0.10') == 0 then
  vim.notify('Your personal config is disabled. Neovim v0.10+ is required.', vim.log.levels.WARN, {})
  return
end

-- HACK: ignore deprecate warnings after upgrading to v0.11
vim.deprecate = function() end ---@diagnostic disable-line: duplicate-set-field

local keymap = require('keymap')

local lazy = require('lazy-nvim')

lazy.init()
keymap.init()

require('autocmd').setup()
lazy.setup()
keymap.setup()
require('env').setup()
require('option').setup()
require('cmd').setup()
require('ftdetect').setup()
require('overrides').setup()
