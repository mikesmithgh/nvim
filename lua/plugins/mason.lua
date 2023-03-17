return {
  { "jayp0521/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    enabled = true,
    config = function()
      local status, mason = pcall(require, "mason")
      if not status then
        return
      end
      mason.setup()

      local masonnvimdap
      status, masonnvimdap = pcall(require, "mason-nvim-dap")
      if not status then
        return
      end
      masonnvimdap.setup({
        ensure_installed = { "python", "delve", "bash" }
      })
    end },

}
