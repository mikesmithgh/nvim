return {
  'mfussenegger/nvim-dap',
  enabled = true,
  lazy = true,
  config = function()
    -- copied from https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/lua/me/dap.lua
    local api = vim.api
    local M = {}
    local log_level = 'INFO'

    local function reload()
      require('dap.repl').close()
      M.setup()
      require('jdtls.dap').setup_dap({ hotcodereplace = 'auto' })
      vim.cmd('set ft=' .. vim.bo.filetype)
      require('dap').set_log_level(log_level)
    end

    function M.setup()
      -- TODO: revist and improve highlights
      local signs = {
        DapBreakpoint = { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' },
        DapBreakpointCondition = {
          text = '',
          texthl = 'DiagnosticError',
          linehl = '',
          numhl = '',
        },
        DapBreakpointRejected = {
          text = '',
          texthl = 'DiagnosticError',
          linehl = '',
          numhl = '',
        },
        DapLogPoint = { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' },
        DapStopped = {
          text = '',
          texthl = 'DiagnosticWarn',
          linehl = 'PmenuSel',
          numhl = 'PmenuThumb',
        },
      }
      for name, opts in pairs(signs) do
        vim.fn.sign_define(name, opts)
      end

      local status, dap = pcall(require, 'dap')
      if not status then
        return
      end

      local orig_set_log_level = dap.set_log_level
      function dap.set_log_level(level)
        orig_set_log_level(level)
        log_level = level
      end

      -- local widgets
      -- status, widgets = pcall(require, "dap.ui.widgets")
      -- if not status then
      --   return
      -- end
      local keymap = vim.keymap
      local function set(mode, lhs, rhs)
        keymap.set(mode, lhs, rhs, { silent = true })
      end

      -- TODO: move mappings to keymaps file

      set('n', '<leader>b', dap.toggle_breakpoint)

      set('n', '<f9>', dap.toggle_breakpoint) -- vscode
      set('i', '<f9>', function()
        dap.toggle_breakpoint()
        vim.cmd.startinsert({ bang = true })
      end)

      set('n', '<leader>B', function()
        dap.toggle_breakpoint(vim.fn.input('Breakpoint Condition: '), nil, nil, true)
      end)
      set('n', '<leader>lp', function()
        dap.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '), true)
      end)

      set('n', '<f5>', dap.continue) -- vscode
      set('i', '<f5>', function()
        dap.continue()
        vim.cmd.startinsert({ bang = true })
      end)

      set('n', '<f11>', dap.step_into) -- vscode
      set('i', '<f11>', function()
        dap.step_into()
        vim.cmd.startinsert({ bang = true })
      end)

      set('n', '<s-f11>', dap.step_out) -- vscode
      set('i', '<s-f11>', function()
        dap.step_out()
        vim.cmd.startinsert({ bang = true })
      end)
      set('n', '<f23>', dap.step_out) -- vscode, same as <s-f11>
      set('i', '<s-f23>', function()
        dap.step_out()
        vim.cmd.startinsert({ bang = true })
      end)

      set('n', '<f10>', dap.step_over) -- vscode
      set('i', '<f10>', function()
        dap.step_over()
        vim.cmd.startinsert({ bang = true })
      end)

      set('n', '<s-f5>', dap.terminate) -- vscode
      set('i', '<s-f5>', function()
        dap.terminate()
        vim.cmd.startinsert({ bang = true })
      end)
      set('n', '<f17>', dap.terminate) -- vscode, same as <s-f5>
      set('i', '<f17>', function()
        dap.terminate()
        vim.cmd.startinsert({ bang = true })
      end)

      local dapuiwidgets
      status, dapuiwidgets = pcall(require, 'dapui.widgets')
      if status then
        set('n', '<f12>', dapuiwidgets.hover)
        set('i', '<f12>', function()
          dapuiwidgets.hover()
          vim.cmd.startinsert({ bang = true })
        end)
      end

      -- set('n', '<leader>dr', function() dap.repl.toggle({ height = 15 }) end)
      set('n', '<leader>dl', dap.run_last)
      set('n', '<leader>dj', dap.down)
      set('n', '<leader>dk', dap.up)
      set('n', '<leader>dc', dap.run_to_cursor)
      set('n', '<leader>df', dap.focus_frame)

      -- set('n', '<leader>dS', function() widgets.centered_float(widgets.frames) end)
      -- set('n', '<leader>dt', function() widgets.centered_float(widgets.threads) end)
      -- set('n', '<leader>ds', function() widgets.centered_float(widgets.scopes) end)
      -- set('n', '<leader>dh', widgets.hover)
      -- set('v', '<leader>dh',
      --   [[<ESC><CMD>lua require'dap.ui.widgets'.hover(require("dap.utils").get_visual_selection_text)<CR>]])

      dap.listeners.before.initialize['dapui_config'] = function()
        local dapui
        status, dapui = pcall(require, 'dapui')
        if not status then
          return
        end
        local dapuiwindows
        status, dapuiwindows = pcall(require, 'dapui.windows')
        if next(dapuiwindows.layouts) == nil then
          dapui.setup()
        end
      end

      dap.listeners.after.event_initialized['dapui_config'] = function()
        local dapui
        status, dapui = pcall(require, 'dapui')
        if not status then
          return
        end
        dapui.open()
      end

      -- local sidebar = widgets.sidebar(widgets.scopes)
      -- api.nvim_create_user_command('DapSidebar', sidebar.toggle, { nargs = 0 })
      api.nvim_create_user_command('DapReload', reload, { nargs = 0 })
      api.nvim_create_user_command('DapBreakpoints', function()
        dap.list_breakpoints(true)
      end, { nargs = 0 })
      -- help dap-configuration
      api.nvim_create_user_command('DapLoadJavaConfigurations', function()
        dap.configurations.java = {
          {
            type = 'java',
            request = 'launch',
            name = 'SrxPortalApplication (local2)',
            mainClass = 'com.srx.portal.SrxPortalApplication',
            -- args = 'server ./target/classes/ingest-profiles.yml',
            -- copied from  Intellij
            vmArgs = '--add-opens=java.base/java.lang=ALL-UNNAMED -Dspring.main.banner-mode=OFF -Dspring.profiles.active=local2 -Dspring.output.ansi.enabled=always -Dcom.sun.management.jmxremote -Dspring.jmx.enabled=true -Dspring.liveBeansView.mbeanDomain -Dspring.application.admin.enabled=true -Dmanagement.endpoints.jmx.exposure.include=*',
            cwd = '/Users/mike/repos/srx-backend/packages/srx-portal-backend',
            modulePaths = { '/Users/mike/repos/srx-backend/packages/srx-portal-backend' },
          },
          {
            type = 'java',
            request = 'launch',
            name = 'SrxPortalApplication (dev)',
            mainClass = 'com.srx.portal.SrxPortalApplication',
            -- args = 'server ./target/classes/ingest-profiles.yml',
            -- copied from  Intellij
            vmArgs = '--add-opens=java.base/java.lang=ALL-UNNAMED -Dspring.main.banner-mode=OFF -Dspring.profiles.active=dev -Dspring.output.ansi.enabled=always -Dcom.sun.management.jmxremote -Dspring.jmx.enabled=true -Dspring.liveBeansView.mbeanDomain -Dspring.application.admin.enabled=true -Dmanagement.endpoints.jmx.exposure.include=*',
            cwd = '/Users/mike/repos/srx-backend/packages/srx-portal-backend',
            modulePaths = { '/Users/mike/repos/srx-backend/packages/srx-portal-backend' },
          },
          -- {
          --   type = 'java',
          --   request = 'launch',
          --   name = 'Ingest Profiles',
          --   mainClass = 'com.brightcove.profiles.ProfilesService',
          --   args = 'server ./target/classes/ingest-profiles.yml',
          --   vmArgs = '-Dhystrix.command.default.fallback.enabled=false',
          --   cwd = '/Users/mike/repos/ingest-profiles/service/webapp',
          --   -- modulePaths = { "/Users/mike/repos/ingest-profiles" }, -- java 9 or greater
          -- },
          -- {
          --   type = 'java',
          --   request = 'launch',
          --   name = 'Run with log4j debug',
          --   mainClass = 'com.brightcove.profiles.dynamo.DynamoDBTestAdd',
          --   -- classPaths = "${Auto}",
          --   args = '',
          --   vmArgs = '-Dlog4j.debug=true',
          --   -- cwd = "${cwd}",
          --   cwd = '/Users/mike/repos/ingest-profiles/service/webapp',
          --   -- modulePaths = { "/Users/mike/repos/ingest-profiles" }, -- java 9 or greater
          -- },
        }
      end, { nargs = 0 })

      -- bash
      dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
      }
      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = 'Launch file',
          showDebugOutput = false,
          pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
          pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
          trace = false,
          file = '${file}',
          program = '${file}',
          cwd = '${workspaceFolder}',
          pathCat = 'cat',
          pathBash = '/opt/homebrew/bin/bash',
          pathMkfifo = 'mkfifo',
          pathPkill = 'pkill',
          args = {},
          env = {},
          terminalKind = 'integrated',
        },
        {
          type = 'bashdb',
          request = 'launch',
          name = 'Launch file with arguments',
          showDebugOutput = false,
          pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
          pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
          trace = false,
          file = '${file}',
          program = '${file}',
          cwd = '${workspaceFolder}',
          pathCat = 'cat',
          pathBash = '/opt/homebrew/bin/bash',
          pathMkfifo = 'mkfifo',
          pathPkill = 'pkill',
          args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, ' +')
          end,
          env = {},
          terminalKind = 'integrated',
        },
      }
    end

    M.setup()

    return M
  end,
}
