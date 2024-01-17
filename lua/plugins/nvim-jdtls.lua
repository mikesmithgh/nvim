-- java jdtls language server is setup independently
-- see ~/.config/nvim/ftplugin/java.lua for configuration
return {
  'mfussenegger/nvim-jdtls',
  enabled = true,
  lazy = true,
  ft = {
    'java',
  },
}
