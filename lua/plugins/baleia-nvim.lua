return {
  'm00qek/baleia.nvim',
  enabled = true,
  commit = '8ba437c',
  cmd = {
    'BaleiaLess',
    'BaleiaColorize',
    'BaleiaClear',
  },
  config = function()
    local baleia = require('baleia').setup()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_create_user_command('BaleiaColorize', function()
      baleia.once(vim.fn.bufnr(bufnr))
    end, {})
    vim.api.nvim_create_user_command('BaleiaLess', function()
      vim.bo.buftype = 'nofile'
      vim.bo.bufhidden = 'wipe'
      vim.bo.swapfile = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.cursorline = false
      vim.opt_local.cursorcolumn = false
      vim.opt_local.laststatus = 0
      vim.opt_local.cmdheight = 0
      vim.opt_local.fillchars:append({ eob = ' ' })
      vim.opt_local.scrolloff = 0
      vim.opt_local.showmode = true
      vim.cmd([[silent! %!sed -E ]] .. [[-e 's/]8;;[^\]*[\]//g' ]] .. [[-e 's/]133;[AC][;k=s]*\\//g' ]] .. [[-e 's/$/[0m/' ]])
      baleia.once(vim.fn.bufnr(bufnr))
    end, {})
    vim.api.nvim_create_user_command('BaleiaClear', function()
      local ns = vim.api.nvim_get_namespaces()['BaleiaColors']
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end, {})
  end,
}
