return {
  'numToStr/Comment.nvim',
  enabled = true,
  lazy = true,
  keys = {
    { '<C-/>', mode = { 'n', 'v', 'o' } },
    { '<C-\\>', mode = { 'n', 'v', 'o' } },
  },
  config = function()
    local status, comment = pcall(require, 'Comment')
    if not status then
      return
    end
    comment.setup({
      padding = true,
      sticky = true,
      ignore = nil, ---@diagnostic disable-line: assign-type-mismatch
      toggler = { line = '<C-/>', block = '<C-\\>' },
      opleader = { line = '<C-/>', block = '<C-\\>' },
      extra = {
        below = nil, ---@diagnostic disable-line: assign-type-mismatch
        above = nil, ---@diagnostic disable-line: assign-type-mismatch
        eol = nil, ---@diagnostic disable-line: assign-type-mismatch
      },
      mappings = { basic = true, extra = false },
      pre_hook = nil, ---@diagnostic disable-line: assign-type-mismatch
      post_hook = nil, ---@diagnostic disable-line: assign-type-mismatch
    })
  end,
}
