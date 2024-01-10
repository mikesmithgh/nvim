return {
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackTest' },
    event = { 'User KittyScrollbackLaunch' },
    dev = true,
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^1.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ','
      require('kitty-scrollback').setup({
        -- global = function()
        --   vim.keymap.set({ 'v' }, 'Y', '<Plug>(KsbVisualYankLine)', {})
        --   vim.keymap.set({ 'v' }, 'y', '<Plug>(KsbVisualYank)', {})
        --   vim.keymap.set({ 'n' }, 'Y', '<Plug>(KsbNormalYankEnd)', {})
        --   vim.keymap.set({ 'n' }, 'y', '<Plug>(KsbNormalYank)', {})
        --   vim.keymap.set({ 'n' }, 'yy', '<Plug>(KsbYankLine)', {})
        --
        --   vim.keymap.set({ 'v' }, '<leader>Y', '"aY', {})
        --   vim.keymap.set({ 'v' }, '<leader>y', '"ay', {})
        --   vim.keymap.set({ 'n' }, '<leader>Y', '"aY', {})
        --   vim.keymap.set({ 'n' }, '<leader>y', '"ay', {})
        --   vim.keymap.set({ 'n' }, '<leader>yy', '"ayy', {})
        --   return {
        --     paste_window = { yank_register = 'a' },
        --   }
        -- end,
      })
    end,
  },
}
