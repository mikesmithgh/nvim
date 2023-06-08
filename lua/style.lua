local M = {}

-- border from https://github.com/AlexvZyl/.dotfiles/blob/main/.config/nvim/lua/alex/utils.lua
M.border = {
  none = { '', '', '', '', '', '', '', '' },
  empty = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  inner_thick = { ' ', '▄', ' ', '▌', ' ', '▀', ' ', '▐' },
  outer_thick = { '▛', '▀', '▜', '▐', '▟', '▄', '▙', '▌' },
  outer_thin = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  inner_thin = { ' ', '▁', ' ', '▏', ' ', '▔', ' ', '▕' },
  top_right_corner_thin = '🭾',
  top_left_corner_thin = '🭽',
  outer_thin_telescope = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
  outer_thick_telescope = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' },
}

return M
