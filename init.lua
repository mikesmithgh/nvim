local keymap = require('keymap')
local lazy = require('lazy-nvim')

vim.g.is_kitty_scrollback_pager = vim.env.KITTY_PIPE_DATA ~= nil and vim.env.KITTY_PIPE_DATA ~= ''

lazy.init()
keymap.init()

lazy.setup()
keymap.setup()
require('env').setup()
require('option').setup()
require('cmd').setup()
require('autocmd').setup()
require('ftdetect').setup()
