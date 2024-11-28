vim.o.conceallevel = 3

vim.keymap.set('n', '<LocalLeader><LocalLeader>j', '<Cmd>FormatJira<CR>', { noremap = true })

vim.keymap.set('n', '<LocalLeader><LocalLeader>s', function()
  local slack_url = vim.fn.expand('<cWORD>')
  vim.cmd.normal({ 'ciW{' .. slack_url .. '}[slack message]', bang = true })
end, { noremap = true })
