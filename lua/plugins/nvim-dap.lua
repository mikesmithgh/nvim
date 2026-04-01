return {
  'mfussenegger/nvim-dap',
  enabled = true,
  lazy = true,
  config = function()
    -- copied from https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/lua/me/dap.lua
    local api = vim.api
    local M = {}

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
      status, dapuiwidgets = pcall(require, 'dap.ui.widgets')
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
      api.nvim_create_user_command('DapBreakpoints', function()
        dap.list_breakpoints(true)
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
      -- c
      -- see https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
      dap.adapters.codelldb = {
        type = 'executable',
        command = 'codelldb',
      }
      -- TODO: add user to 'Developer Tools' group. Sigh security 😭
      dap.configurations.c = {
        {
          name = 'codelldb launch',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ' .. vim.fn.getcwd() .. '/')
          end,
          cwd = '${workspaceFolder}',
          terminal = 'integrated',
          stopOnEntry = false,
        },
        {
          name = 'codelldb attach',
          type = 'codelldb',
          request = 'attach',
          pid = function()
            return vim.fn.input('pid: ')
          end,
          cwd = '${workspaceFolder}',
          terminal = 'integrated',
          stopOnEntry = false,
          waitFor = true,
        },
      }
    end

    M.setup()

    return M
  end,
}
