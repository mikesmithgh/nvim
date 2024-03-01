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

  vim.api.nvim_create_autocmd({ 'User' }, {
    group = vim.api.nvim_create_augroup('VeryLazyAfterIntro', { clear = true }),
    pattern = { 'VeryLazy' },
    callback = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      if next(vim.fn.argv()) ~= nil then
        vim.api.nvim_exec_autocmds('User', { pattern = 'IntroDone', modeline = false })
      else
        if vim.env.KITTY_SCROLLBACK_NVIM ~= 'true' then
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'ModeChanged', 'InsertEnter' }, {
            group = vim.api.nvim_create_augroup('AfterIntro', { clear = true }),
            pattern = { '<buffer=1>' },
            callback = function()
              vim.api.nvim_exec_autocmds('User', { pattern = 'IntroDone', modeline = false })
              return true
            end,
          })
        end
      end
      return true
    end,
  })

  vim.api.nvim_create_autocmd({ 'StdinReadPost', 'WinEnter' }, {
    group = vim.api.nvim_create_augroup('PostAfterIntro', { clear = true }),
    callback = function()
      vim.api.nvim_exec_autocmds('User', { pattern = 'IntroDone', modeline = false })
      return true
    end,
  })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = vim.api.nvim_create_augroup('WinNewBorderline', { clear = true }),
    pattern = { '*' },
    callback = function()
      vim.cmd.Borderline()
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
          vim.api.nvim_exec_autocmds('User', { pattern = 'IntroDone' })
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

  vim.api.nvim_create_autocmd('User', {
    pattern = 'NotVeryLazy',
    once = true,
    callback = function()
      vim.defer_fn(function()
        local kls = require('lspconfig.configs')['kotlin_language_server']
        local util = require('lspconfig.util')
        local proj_root = util.root_pattern('settings.gradle', '.git')(vim.fn.getcwd())
        kls.manager.add(proj_root)
        local winid = nil
        local bufid = nil
        local count = 0
        local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        local msg = 'Starting language server...'
        vim.fn.timer_start(80, function()
          count = count + 1
          if count > #spinner then
            count = 1
          end
          local client = 'kotlin_language_server'
          local fmt_msg = ' ' .. spinner[count] .. ' ' .. msg .. ' ' .. client
          local winconfig = {
            relative = 'editor',
            width = #fmt_msg - 1,
            height = 2,
            row = vim.o.lines - 1,
            col = vim.o.columns,
            style = 'minimal',
            focusable = false,
            zindex = 55,
            anchor = 'SE',
          }

          if winid and not pcall(vim.api.nvim_win_get_config, winid) then
            winid = nil
          end
          if bufid and not pcall(vim.api.nvim_buf_get_name, bufid) then
            bufid = nil
          end

          if winid then
            vim.api.nvim_win_set_config(winid, winconfig)
          else
            bufid = vim.api.nvim_create_buf(false, true)
            winid = vim.api.nvim_open_win(bufid, false, winconfig)
          end
          if not bufid then
            bufid = vim.api.nvim_create_buf(false, true)
            winid = vim.api.nvim_win_set_buf(winid, bufid)
          end
          vim.api.nvim_buf_set_lines(bufid, 0, -1, false, {})
          vim.api.nvim_buf_set_lines(bufid, 0, -1, false, {
            fmt_msg,
          })
          -- vim.api.nvim_buf_clear_namespace(bufid, -1, 1, -1)
          local nid = vim.api.nvim_create_namespace('mike')
          local startcol = 0
          local endcol = #spinner[count] + 2
          vim.api.nvim_buf_set_extmark(bufid, nid, 0, startcol, {
            hl_group = 'NoiceLspProgressSpinner',
            end_col = endcol,
          })
          startcol = endcol
          endcol = endcol + #msg
          vim.api.nvim_buf_set_extmark(bufid, nid, 0, startcol, {
            hl_group = 'NoiceLspProgressTitle',
            end_col = endcol,
          })
          startcol = endcol
          endcol = #fmt_msg
          vim.api.nvim_buf_set_extmark(bufid, nid, 0, startcol, {
            hl_group = 'NoiceLspProgressClient',
            end_col = endcol,
          })
        end, {
          ['repeat'] = -1,
        })
      end, 1)
    end,
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
