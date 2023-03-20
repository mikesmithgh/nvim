return {
  'mfussenegger/nvim-dap-python',
  dependencies = { "mfussenegger/nvim-dap" },
  enabled = true,
  config = function()
    local status, dap = pcall(require, "dap")
    if not status then
      return
    end
    local dappython
    status, dappython = pcall(require, "dap-python")
    if not status then
      return
    end
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file (justMyCode = false)',
        program = '${file}',
        justMyCode = false,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file with arguments (justMyCode = false)',
        program = '${file}',
        justMyCode = false,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, " +")
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file (console = integratedTerminal, justMyCode = false)',
        program = '${file}',
        console = "integratedTerminal",
        justMyCode = false,
        -- pythonPath = opts.pythonPath,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file with arguments (console = integratedTerminal, justMyCode = false)',
        program = '${file}',
        console = "integratedTerminal",
        justMyCode = false,
        -- pythonPath = opts.pythonPath,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, " +")
        end,
      },
    }
    dappython.setup('~/.virtualenvs/debugpy/bin/python', {
      include_configs = true,
      console = 'integratedTerminal',
      pythonPath = nil,
    })
  end
}
