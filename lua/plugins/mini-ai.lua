return {
  'echasnovski/mini.ai',
  enabled = true,
  version = false,
  config = function()
    require('mini.ai').setup({
      custom_textobjects = {
        -- Whole buffer
        -- g = function()
        --   local from = { line = 1, col = 1 }
        --   local to = {
        --     line = vim.fn.line('$'),
        --     col = math.max(vim.fn.getline('$'):len(), 1),
        --   }
        --   return { from = from, to = to }
        -- end,
      },
    })
  end,
}
