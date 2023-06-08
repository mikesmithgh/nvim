return {
  'knubie/vim-kitty-navigator',
  enabled = false,
  init = function()
    vim.g.kitty_navigator_no_mappings = 1

    vim.keymap.set('n', '<c-w>h', '<cmd>KittyNavigateLeft<cr>', { noremap = true, silent = true })
    vim.keymap.set('n', '<c-w>j', '<cmd>KittyNavigateDown<cr>', { noremap = true, silent = true })
    vim.keymap.set('n', '<c-w>k', '<cmd>KittyNavigateUp<cr>', { noremap = true, silent = true })
    vim.keymap.set('n', '<c-w>l', '<cmd>KittyNavigateRight<cr>', { noremap = true, silent = true })
  end,
}
