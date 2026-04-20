-- !!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!! this is actually important stuff, don't ignore me this time
-- !!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!
-- stay tuned, https://github.com/nvim-treesitter/nvim-treesitter is listed as archived 😢
-- # upgrade path from master
-- # branch = 'main'
-- # a bit nuclear but for good measure 😂
-- mv ~/.local/share/nvim ~/.local/share/nvim-bak
-- # sync lazy.nvim
-- note: ensure installed is no longer in config, we explicilty call install and it will noop if already installed

-- This probably ties this config to nvim 0.12+, I assum ebreaking changes are expected on older version of Neovim

return {
  {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    -- main has a full rewrite which is breaking my config, pin to master
    branch = 'main', -- on main now, there is no turning back! don't go to master or you will have a bad time
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup(
        -- leaving comment for reference, just let nvim-treesitter do its defaults
        -- -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
        -- install_dir = vim.fn.stdpath('data') .. '/site',
      )

      -- Tiltfiles are written in Starlark, a dialect of Python, https://docs.tilt.dev/api.html
      vim.treesitter.language.register('starlark', { 'tiltfile' })

      require('nvim-treesitter').install({
        -- TOOD: lets revisit if all these are necessary
        'bash',
        -- 'c', -- provided by nvim
        'comment',
        'cpp',
        -- 'lua', -- provided by nvim
        'diff',
        'dockerfile',
        'fish',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'go',
        'gomod',
        'gowork',
        'gotmpl',
        -- 'help',
        'helm',
        'html',
        'http',
        'java',
        'javascript',
        'jq',
        'jsdoc',
        'json',
        -- 'json5', -- I think this was causing vi to crash on startup on 8/14/2023
        'lua',
        'make',
        -- 'markdown', -- provided by nvim
        -- 'markdown_inline', -- provided by nvim
        -- 'norg', -- nvim-treesitter does not know about norg in parsers.lua, handled by Neorg
        -- 'norg_meta', -- nvim-treesitter does not know about norg_meta in parsers.lua, handled by Neorg
        -- 'query', -- provided by nvim
        'python',
        'regex',
        'ruby',
        'scala',
        'sql',
        'terraform',
        'todotxt',
        'toml',
        'typescript',
        -- 'vim', -- provided by nvim
        -- 'vimdoc', -- provided by nvim
        'yaml',
      })
    end,
  },
  {
    'nvim-treesitter/playground',
    enabled = true,
    lazy = true,
    cmd = {
      'TSPlaygroundToggle',
    },
  },
}
