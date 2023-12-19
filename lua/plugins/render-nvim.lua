return {
  {
    'mikesmithgh/render.nvim',
    -- dir = '~/gitrepos/render.nvim/.worktrees/ci',
    enabled = false,
    lazy = false,
    dev = true,
    init = function()
      require('render').setup({
        notify = {
          level = vim.log.levels.TRACE,
        },
      })
    end,
  },
}
