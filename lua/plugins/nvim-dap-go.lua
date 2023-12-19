return {
  'leoluz/nvim-dap-go',
  enabled = true,
  dependencies = { 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' },
  config = function()
    local status, Job = pcall(require, 'plenary.job')
    if not status then
      return
    end

    local dap
    status, dap = pcall(require, 'dap')
    if not status then
      return
    end
    local dapgo
    status, dapgo = pcall(require, 'dap-go')
    if not status then
      return
    end

    dapgo.setup()

    -- copied from dap-go
    local function filtered_pick_process()
      local opts = {}
      vim.ui.input({ prompt = 'Search by process name (lua pattern), or hit enter to select from the process list: ' }, function(input)
        opts['filter'] = input or ''
      end)
      return require('dap.utils').pick_process(opts)
    end

    local delve_config = {
      -- time to wait for delve to initialize the debug session.
      -- default to 20 seconds
      initialize_timeout_sec = 20,
      -- a string that defines the port to start delve debugger.
      -- default to string "${port}" which instructs nvim-dap
      -- to start the process in a random available port
      port = '4040',
    }

    local dap_configs = {
      {
        type = 'go',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
        buildFlags = delve_config.build_flags,
      },
      {
        type = 'go',
        name = ' Debug (Arguments)',
        request = 'launch',
        program = '${file}',
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, ' +')
        end,
        buildFlags = delve_config.build_flags,
      },
      {
        type = 'go',
        name = 'Debug Package',
        request = 'launch',
        program = '${fileDirname}',
        buildFlags = delve_config.build_flags,
      },
      {
        type = 'go',
        name = ' Debug Package (Arguments)',
        request = 'launch',
        program = '${fileDirname}',
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, ' +')
        end,
      },
      {
        type = 'go',
        name = 'Attach',
        mode = 'local',
        request = 'attach',
        processId = filtered_pick_process,
        buildFlags = delve_config.build_flags,
      },
      {
        type = 'go',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}',
        buildFlags = delve_config.build_flags,
      },
      {
        type = 'go',
        name = 'Debug test (go.mod)',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
        buildFlags = delve_config.build_flags,
      },
      {
        type = 'go',
        name = ' Attach Remote',
        mode = 'remote',
        request = 'attach',
      },
      {
        type = 'go',
        name = ' Remote Debug (Boulder)',
        request = 'attach',
        mode = 'remote',
        port = 4040,
        debugAdapter = 'dlv-dap',
        host = '127.0.0.1',
        substitutePath = {
          {
            from = '${workspaceFolder}',
            to = '/boulder',
          },
        },
        before = function()
          Job:new({
            command = 'pkill',
            args = { 'dlv' },
            on_exit = function(_, return_val)
              if return_val == 0 then
                print('found dlv running, killed it (this is a hack)')
              end
            end,
          }):sync() -- or start()
        end,
      },
    }

    -- hack is a hack
    dap.configurations.go = vim.tbl_map(function(c)
      c.before = function()
        Job:new({
          command = 'pkill',
          args = { 'dlv' },
          on_exit = function(_, return_val)
            if return_val == 0 then
              print('found dlv running, killed it (this is a hack)')
            end
          end,
        }):sync() -- or start()
      end
      return c
    end, dap_configs)
  end,
}
