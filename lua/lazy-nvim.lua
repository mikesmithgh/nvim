local M = {}

M.init = function()
  -- package manager
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

M.setup = function()
  require("lazy").setup("plugins", {
    dev = {
      -- directory where you store your local plugin projects
      path = "~/gitrepos/",
      ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
      patterns = {
        "mikesmithgh",
      },
      fallback = false, -- Fallback to git when local plugin doesn't exist
    },
    install = {
      -- install missing plugins on startup. This doesn't increase startup time.
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { "gruvsquirrel" },
    },
  })
end

return M
