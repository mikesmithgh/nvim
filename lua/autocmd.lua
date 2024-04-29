local M = {}

M.setup = function()
  vim.api.nvim_create_augroup('Unhighlight', { clear = true })
  vim.api.nvim_create_augroup('Backup', { clear = true })
  -- vim.api.nvim_create_augroup('LspOnStartup', { clear = true })

  vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
    group = vim.api.nvim_create_augroup('CmdlineEnterRemoveIncRename', { clear = true }),
    pattern = { ':' },
    callback = function()
      -- prevents errors when navigating previous command history
      vim.fn.histdel('cmd', 'IncRename.*')
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
      vim.api.nvim_notify('To execute the command you must write the buffer contents.', vim.log.levels.WARN, {})
      return true
    end,
  })

  -- TODO: revisit this due to CursorHold
  vim.api.nvim_create_autocmd({ 'InsertEnter', 'TextChanged' }, {
    group = 'Unhighlight',
    pattern = { '*' },
    callback = function()
      vim.opt_local.hlsearch = false
    end,
  })

  vim.api.nvim_create_augroup('Backup', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = 'Backup',
    pattern = { '*' },
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

  vim.api.nvim_create_user_command('Woman', function(params)
    local man = require('man')
    if params.bang then
      man.init_pager()
    else
      -- TODO: there is probably a better way to write this
      local vertical_help = true
      local man_ok, man_err = pcall(man.open_page, params.count, params.smods, params.fargs)
      if not man_ok then
        vim.notify(man.errormsg or man_err, vim.log.levels.INfO)
        vertical_help = false
      end
      local help_ok, help_err
      help_ok, help_err = pcall(vim.api.nvim_cmd, { cmd = 'help', args = params.fargs, mods = { vertical = vertical_help } }, {})
      if not help_ok then
        vim.notify(help_err, vim.log.levels.INFO)
      end
    end
  end, {
    bang = true,
    bar = true,
    addr = 'other',
    nargs = '*',
    complete = function(...)
      -- TODO: add help completion
      return require('man').man_complete(...)
    end,
  })

  -- no longer using because conform is handling it with gofmt and goimports
  -- Auto-format files prior to saving them
  -- (async = false is the default for format)
  -- vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  --   group = vim.api.nvim_create_augroup('GoFormatSave', { clear = true }),
  --   pattern = { '*.go' },
  --   callback = function()
  --     vim.lsp.buf.format({ async = false })
  --   end,
  -- })

  -- vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  --   group = vim.api.nvim_create_augroup('FormatLuaSave', { clear = true }),
  --   pattern = { '*.lua' },
  --   command = 'normal! mzHmygggqG`yzt`z',
  -- })

  vim.api.nvim_create_user_command('WithRole', function()
    local creds_file_path = vim.api.nvim_get_runtime_file('tmp/temp-aws-creds.json', false)
    if next(creds_file_path) == nil then
      vim.notify('creds file not found', vim.log.levels.ERROR, {})
      return
    end
    local creds_file = io.open(creds_file_path[1], 'r')
    if not creds_file then
      vim.notify('cannot open creds file', vim.log.levels.ERROR, {})
      return
    end
    local json = creds_file:read('*a')
    creds_file:close()
    local aws_creds_tbl = vim.json.decode(json, {})
    if not aws_creds_tbl then
      vim.notify('creds json is nil', vim.log.levels.ERROR, {})
      return
    end
    vim.env.AWS_ACCESS_KEY_ID = aws_creds_tbl.AccessKeyId
    vim.env.AWS_SECRET_ACCESS_KEY = aws_creds_tbl.SecretAccessKey
    vim.env.AWS_SESSION_TOKEN = aws_creds_tbl.SessionToken
    vim.env['CSI_CRONJOB_PUBLIC_FILEPATH'] = '_test/local/public.yaml'
    vim.env['CSI_CRONJOB_SECRET_FILEPATH'] = '_test/local/secret.yaml'
  end, {
    bang = true,
    bar = true,
    addr = 'other',
    nargs = 0,
  })
end
-- when switching to a terminal window, automatically switch to insert mode
-- see: https://vi.stackexchange.com/a/43781/36430
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  pattern = { '*' },
  callback = function()
    if vim.env.KITTY_SCROLLBACK_NVIM ~= 'true' and vim.o.buftype == 'terminal' then
      vim.cmd(':startinsert')
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
        vim.api.nvim_notify('Using a bob neovim instance', vim.log.levels.WARN, {})
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
