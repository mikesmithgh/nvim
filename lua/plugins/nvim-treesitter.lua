return {
  {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    branch = 'main',
    dependencies = 'nvim-neorg/tree-sitter-norg',
    lazy = false,
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/playground',
    enabled = true,
    lazy = true,
    cmd = {
      'TSPlaygroundToggle',
    },
  },
}
