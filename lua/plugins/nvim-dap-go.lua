return {
  'leoluz/nvim-dap-go',
  enabled = true,
  lazy = true,
  ft = { 'go' },
  dependencies = { 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' },
  config = function()
    local dap_go = require('dap-go')
    dap_go.setup()

    -- copied from dap-go
    local function filtered_pick_process()
      local opts = {}
      vim.ui.input({ prompt = 'Search by process name (lua pattern), or hit enter to select from the process list: ' }, function(input)
        opts['filter'] = input or ''
      end)
      return require('dap.utils').pick_process(opts)
    end

    -- not using dap-go setup to avoid duplicate entries
    require('dap').configurations.go = {
      {
        type = 'go',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = ' Debug (Arguments)',
        request = 'launch',
        program = '${file}',
        args = dap_go.get_arguments,
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = ' Debug (Arguments & Build Flags)',
        request = 'launch',
        program = '${file}',
        args = dap_go.get_arguments,
        buildFlags = dap_go.get_build_flags,
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = 'Debug Package',
        request = 'launch',
        program = '${fileDirname}',
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = ' Debug Package (Arguments)',
        request = 'launch',
        program = '${fileDirname}',
        args = dap_go.get_arguments,
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = 'Attach',
        mode = 'local',
        request = 'attach',
        processId = filtered_pick_process,
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}',
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = 'Debug test (go.mod)',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
        outputMode = 'remote',
      },
      {
        type = 'go',
        name = ' Attach Remote',
        mode = 'remote',
        request = 'attach',
        outputMode = 'remote',
      },
    }
  end,
}
