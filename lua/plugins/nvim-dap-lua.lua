return {
  'jbyuki/one-small-step-for-vimkind',
  enabled = true,
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
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

    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
      },
    }

    dap.adapters.nlua = function(callback, config)
      callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
  end,
}
