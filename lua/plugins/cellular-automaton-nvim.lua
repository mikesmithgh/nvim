return {
  'eandrju/cellular-automaton.nvim',
  enabled = false,
  lazy = true,
  cmd = 'CellularAutomaton',
  config = function()
    require('cellular-automaton')
  end,
}
