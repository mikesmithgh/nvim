local status, osv = pcall(require, "osv")
if not status then
  return
end

vim.keymap.set('n', '<leader><f5>', function() osv.launch({ port = 8086 }) end, { silent = true })
