local keymap = require('keymap')
local lazy = require('lazy-nvim')

lazy.init()
keymap.init()

lazy.setup()
keymap.setup()
require('env').setup()
require('option').setup()
require('cmd').setup()
require('autocmd').setup()
require('ftdetect').setup()
