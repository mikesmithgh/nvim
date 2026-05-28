local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
    group = vim.api.nvim_create_augroup('CmdlineEnterRemoveIncRename', { clear = true }),
    pattern = { ':' },
    callback = function()
      -- prevents errors when navigating previous command history
      vim.fn.histdel('cmd', 'IncRename.*')
    end,
  })

  vim.api.nvim_create_autocmd({ 'User' }, {
    group = vim.api.nvim_create_augroup('VeryLazyAfterIntro', { clear = true }),
    pattern = { 'VeryLazy' },
    callback = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      if next(vim.fn.argv()) ~= nil then
        vim.api.nvim_exec_autocmds('User', { pattern = 'AfterIntro', modeline = false })
      else
        if vim.env.KITTY_SCROLLBACK_NVIM ~= 'true' then
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'ModeChanged', 'InsertEnter' }, {
            group = vim.api.nvim_create_augroup('AfterIntro', { clear = true }),
            callback = function()
              vim.api.nvim_exec_autocmds('User', { pattern = 'AfterIntro', modeline = false })
              return true
            end,
          })
        end
      end
      return true
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = vim.api.nvim_create_augroup('BashFCRemoveFile', { clear = true }),
    pattern = { 'bash-fc.*' },
    callback = function()
      vim.cmd('silent! !rm <afile>')
    end,
  })

  vim.api.nvim_create_autocmd({ 'FileChangedShell' }, {
    group = vim.api.nvim_create_augroup('BashFCChangedShell', { clear = true }),
    pattern = { 'bash-fc.*' },
    callback = function()
      local ok, incline = pcall(require, 'incline')
      if ok then
        vim.schedule(function()
          incline.disable()
        end)
      end
      vim.notify('To execute the command you must write the buffer contents.', vim.log.levels.WARN, {})
      return true
    end,
  })

  -- TODO: revisit this due to CursorHold
  vim.api.nvim_create_autocmd({ 'InsertEnter', 'TextChanged' }, {
    group = vim.api.nvim_create_augroup('Unhighlight', { clear = true }),
    pattern = { '*' },
    callback = function()
      vim.opt_local.hlsearch = false
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = vim.api.nvim_create_augroup('Backup', { clear = true }),
    callback = function()
      -- thank you https://gist.github.com/nepsilon/003dd7cfefc20ce1e894db9c94749755
      vim.opt.backupext = '.' .. vim.fn.strftime('%Y%m%dT%H%M%S') .. '.bak'
    end,
  })

  vim.api.nvim_create_user_command('DiffOrig', function()
    -- TODO: make this not gross
    -- TODO: saw something similar on this week in neovim , check it out to see if it is different
    vim.cmd(
      'let temp_ft=&ft | vert new | setlocal shortmess=a | set noswapfile | setlocal bufhidden=wipe | setlocal buftype=nofile | r ++edit # | silent 0d_ | let &ft=temp_ft | setlocal nomodifiable | diffthis | wincmd p | diffthis'
    )
  end, {})
end

-- highlight yanks after yanking
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = vim.api.nvim_create_augroup('TextYankPostGroup', { clear = true }),
  callback = function()
    local hl_op = vim.fn.has('nvim-0.13') == 0 and 'on_yank' or 'hl_op'
    vim.hl[hl_op]({
      higroup = 'Visual',
      timeout = 300,
      on_visual = false,
    })
    local event = vim.v.event
    if vim.fn.reg_executing() ~= '' or event.operator ~= 'y' or vim.regtype == '' or event.visual then
      return
    end
    if vim.o.cursorline then
      vim.o.cursorline = false
      vim.defer_fn(function()
        vim.o.cursorline = true
      end, 300)
    end
  end,
})

-- Bob specific autocmds https://github.com/MordechaiHadad/bob
if vim.env.VIM:match('.*%.local/share/bob.*') then
  vim.api.nvim_create_autocmd({ 'User' }, {
    group = vim.api.nvim_create_augroup('BobNvimIntroDone', { clear = true }),
    pattern = { 'VeryLazy' },
    callback = function()
      vim.defer_fn(function()
        vim.notify('Using a bob neovim instance', vim.log.levels.WARN, {})
      end, 1000)
      return true
    end,
  })
end

-- Kitty specific autocmds
if vim.env.TERM == 'xterm-kitty' then
  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    group = vim.api.nvim_create_augroup('KittySetVarVimEnter', { clear = true }),
    callback = function()
      io.stdout:write('\x1b]1337;SetUserVar=in_editor=MQo\007')
      return true
    end,
  })

  vim.api.nvim_create_autocmd({ 'VimLeave' }, {
    group = vim.api.nvim_create_augroup('KittyUnsetVarVimLeave', { clear = true }),
    callback = function()
      io.stdout:write('\x1b]1337;SetUserVar=in_editor\007')
      return true
    end,
  })
end

return M
