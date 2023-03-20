local keymap = require('keymap')
local lazy = require('lazy-nvim')

lazy.init()
keymap.init()

lazy.setup()
keymap.setup()
require('option').setup()
require('autocmd').setup()
require('ftdetect').setup()
