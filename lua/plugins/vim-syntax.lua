return {
  {
    -- kinesis advantage
    'arjenl/vim-kinesis',
    enabled = false,
  },
  {
    -- applescript
    'vim-scripts/applescript.vim',
    enabled = false,
  },
  {
    -- kitty.conf
    'fladson/vim-kitty',
    enabled = true,
    lazy = true,
    ft = {
      'kitty',
    },
  },
  {
    -- plant uml
    'aklt/plantuml-syntax',
    enabled = true,
    ft = {
      'plantuml',
    },
  },
}
