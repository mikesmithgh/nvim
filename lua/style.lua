local M = {}

-- border from https://github.com/AlexvZyl/.dotfiles/blob/main/.config/nvim/lua/alex/utils.lua
M.border = {
  none = { '', '', '', '', '', '', '', '' },
  empty = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  inner_thick = { ' ', '▄', ' ', '▌', ' ', '▀', ' ', '▐' },
  outer_thick = { '▛', '▀', '▜', '▐', '▟', '▄', '▙', '▌' },
  inner_thin = { ' ', '▁', ' ', '▏', ' ', '▔', ' ', '▕' },

  thinblock = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  thinblock_nobottom = { '🭽', '▔', '🭾', '▕', '▕', ' ', '▏', '▏' },
  thinblock_notop = { '▏', ' ', '▕', '▕', '🭿', '▁', '🭼', '▏' },

  thinblock_topright = '🭾',
  thinblock_topleft = '🭽',

  outer_thin_telescope_bottom_prompt = { ' ', '▕', '▁', '▏', '▏', '▕', '🭿', '🭼' },
  outer_thin_telescope_top_prompt = { '▔', '▕', ' ', '▏', '🭽', '🭾', '▕', '▏' },
  outer_thin_telescope_dropdown_prompt = { ' ', '▕', ' ', '▏', '▏', '▕', ' ', ' ' },
  outer_thick_telescope = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' },
}

M.telescope_fmt = function(b)
  return { b[2], b[4], b[6], b[8], b[1], b[3], b[5], b[7] }
end

return M
