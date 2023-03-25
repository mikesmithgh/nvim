return {
  'numToStr/Comment.nvim',
  enabled = true,
  config = function()
    local status, comment = pcall(require, 'Comment')
    if not status then
      return
    end
    comment.setup({
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = { line = '<c-/>', block = '<c-?>' },
      opleader = { line = '<c-/>', block = '<c-?>' },
      extra = {},
      mappings = { basic = true, extra = false },
      pre_hook = nil,
      post_hook = nil,
    })
  end,
}
