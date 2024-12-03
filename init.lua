if vim.g.vscode then
  vim.notify('Your personal config is disabled. VSCode Neovim is not supported.', vim.log.levels.WARN, {})
  return
end

if vim.fn.has('nvim-0.10') == 0 then
  vim.notify('Your personal config is disabled. Neovim v0.10+ is required.', vim.log.levels.WARN, {})
  return
else
  if vim.fn.has('nvim-0.11') == 0 then
    require('backport').setup()
  end
end

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
