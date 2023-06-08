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
      vim.opt_local.rulerformat = '%5(%1*󰄛 %2* %3*%)'
      vim.opt_local.virtualedit = 'block,onemore'
      vim.api.nvim_set_hl(0, 'User1', { link = 'ModeMsg' })
      vim.api.nvim_set_hl(0, 'User2', { link = 'ErrorMsg' })
      vim.api.nvim_set_hl(0, 'User3', { link = 'DevIconVim' })
      vim.cmd([[silent! %s/.*\\//g]])
      baleia.once(vim.fn.bufnr(bufnr))

      vim.api.nvim_create_augroup('CmdHeightToggle', { clear = true })
      vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
        group = 'CmdHeightToggle',
        pattern = { '*:n' },
        callback = function()
          vim.opt_local.cmdheight = 0
        end,
      })
      vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
        group = 'CmdHeightToggle',
        pattern = { 'n:*' },
        callback = function()
          vim.opt_local.cmdheight = 1
        end,
      })
    end, {})
    vim.api.nvim_create_user_command('BaleiaClear', function()
      local ns = vim.api.nvim_get_namespaces()['BaleiaColors']
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end, {})
  end,
}
