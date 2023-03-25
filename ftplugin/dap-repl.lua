-- referenced https://github.com/mfussenegger/dotfiles/blob/master/vim/.config/nvim/ftplugin/dap-repl.vim

vim.keymap.set('n', 'gF', '<c-w>sgF', { buffer = true })

vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.colorcolumn = ''
vim.opt_local.cursorcolumn = false

require('dap.ext.autocompl').attach()
