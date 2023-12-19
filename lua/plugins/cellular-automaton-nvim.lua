return {
  'eandrju/cellular-automaton.nvim',
  enabled = true,
  lazy = true,
  cmd = 'CellularAutomaton',
  config = function()
    require('cellular-automaton')
  end,
}
