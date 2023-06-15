return {
  {
    'mikesmithgh/render.nvim/render.nvim',
    -- dir = '~/gitrepos/render.nvim/.worktrees/ci',
    enabled = true,
    lazy = false,
    dev = true,
    init = function()
      require('render').setup(
        -- {
        --   notify = {
        --     level = vim.log.levels.INFO,
        --   },
        -- }
      )
    end,
  },
}
