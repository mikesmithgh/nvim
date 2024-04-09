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
