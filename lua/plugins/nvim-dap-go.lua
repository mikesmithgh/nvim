return {
  "leoluz/nvim-dap-go",
  enabled = true,
  dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
  config = function()
    local status, Job = pcall(require, "plenary.job")
    if not status then
      return
    end

    local dap
    status, dap = pcall(require, "dap")
    if not status then
      return
    end
    local dapgo
    status, dapgo = pcall(require, "dap-go")
    if not status then
      return
    end

    dapgo.setup {
      -- Additional dap configurations can be added.
      -- dap_configurations accepts a list of tables where each entry
      -- represents a dap configuration. For more details do:
      -- :help dap-configuration
      dap_configurations = {
        {
          -- Must be "go" or it will be ignored by the plugin
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
        {
          type = "go",
          name = "Debug boulder-wfe2",
          request = "launch",
          mode = "debug",
          args = { "--config", "/Users/mike/go/src/github.com/letsencrypt/boulder/test/config/wfe2-local.json" },
          program = "/Users/mike/go/src/github.com/letsencrypt/boulder/cmd/boulder/main.go",
          output = "boulder-wfe2",
          cwd = "/Users/mike/go/src/github.com/letsencrypt/boulder",
          -- stopOnEntry = true,
        },
        {
          type = "go",
          name = "Remote Debug boulder-wfe2",
          request = "attach",
          mode = "remote",
          port = 4040,
          debugAdapter = "dlv-dap",
          host = "127.0.0.1",
          substitutePath = {
            {
              from = "${workspaceFolder}",
              to = "/boulder",
            }
          },
          before = function()
            Job:new({
              command = 'pkill',
              args = { 'dlv' },
              on_exit = function(_, return_val)
                if return_val == 0 then
                  print("found dlv running, killed it (this is a hack)")
                end
              end,
            }):sync() -- or start()
          end,
        },
        {
          type = "go",
          name = "Remote Debug testing",
          request = "attach",
          mode = "remote",
          port = 40000,
          debugAdapter = "dlv-dap",
          host = "127.0.0.1",
          -- showLog= true,
          -- trace= "log",
          -- logOutput= "rpc",
          substitutePath = {
            {
              from = "${workspaceFolder}",
              to = "/debuggingTutorial",
            }
          }
        },
      },
      -- delve configurations
      delve = {
        -- time to wait for delve to initialize the debug session.
        -- default to 20 seconds
        initialize_timeout_sec = 20,
        -- a string that defines the port to start delve debugger.
        -- default to string "${port}" which instructs nvim-dap
        -- to start the process in a random available port
        port = "4040"
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
              print("found dlv running, killed it (this is a hack)")
            end
          end,
        }):sync() -- or start()
      end
      return c
    end, dap.configurations.go)
  end,
}
