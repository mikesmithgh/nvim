vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.opt.runtimepath:append('/Users/mike/gitrepos/kitty-scrollback.nvim')

vim.keymap.set({ 'n' }, '<C-e>', '5<C-e>', {})
vim.keymap.set({ 'n' }, '<C-y>', '5<C-y>', {})
vim.keymap.set({ 'n' }, '<C-h>', '3h', {})
vim.keymap.set({ 'n' }, '<C-j>', '5j', {})
vim.keymap.set({ 'n' }, '<C-k>', '5k', {})
vim.keymap.set({ 'n' }, '<C-l>', '3l', {})
vim.keymap.set({ 'v' }, '<C-h>', '3h', {})
vim.keymap.set({ 'v' }, '<C-j>', '5j', {})
vim.keymap.set({ 'v' }, '<C-k>', '5k', {})
vim.keymap.set({ 'v' }, '<C-l>', '3l', {})

require('kitty-scrollback').setup()
