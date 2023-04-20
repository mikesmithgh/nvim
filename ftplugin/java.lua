-- referenced https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L1-L149

-- jdtls is required to be installed
-- e.g, brew install jdtls
local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end

-- my preferred tab config for java
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

-- below is lsp and dap stuff

local jdtlssetup
status, jdtlssetup = pcall(require, 'jdtls.setup')
if not status then
  return
end
local root_dir = jdtlssetup.find_root({ '.git', 'gradlew', 'mvnw' })
local home = os.getenv('HOME')
local workspace_folder = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
--
if not vim.g.jdtls then
  local java_home = vim.env.JAVA_HOME
  print(java_home)
  local java_version =
    string.gsub(vim.fn.system([[/usr/libexec/java_home --verbose |& grep 'Amazon Corretto 11' | awk '{ print $9 }']]), '%s+', '')
  print(java_version)
  local java_major_version = string.match(java_version, '%d+') -- split by . and get first match
  print(java_major_version)
  local java_runtime = 'Corretto-' .. java_major_version
  print(java_runtime)
  -- local java_runtime = 'JavaSE-' .. java_major_version
  vim.g.jdtls = {
    java_home = java_home,
    java_version = java_version,
    java_major_version = java_major_version,
    java_runtime = java_runtime,
    java = java_home .. '/bin/java',
  }
end

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    vim.g.jdtls.java,

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    '/opt/homebrew/opt/jdtls/libexec/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    '-configuration',
    '/opt/homebrew/opt/jdtls/libexec/config_mac',

    '-data',
    workspace_folder,
  },
  settings = {
    java = {
      home = vim.g.jdtls.java_home,
      configuration = {
        runtimes = {
          {
            name = vim.g.jdtls.java_runtime,
            path = vim.g.jdtls.java_home,
            default = true,
          },
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 6,
          staticStarThreshold = 6,
        },
      },
    },
  },
}

local on_attach = function(_, bufnr)
  -- copied from https://github.com/mfussenegger/nvim-jdtls/wiki/Sample-Configurations
  jdtlssetup.add_commands()
  jdtls.setup_dap({ hotcodereplace = 'auto' })

  --   require 'lsp-status'.register_progress()
  --   require 'compe'.setup {
  --     enabled = true;
  --     autocomplete = true;
  --     debug = false;
  --     min_length = 1;
  --     preselect = 'enable';
  --     throttle_time = 80;
  --     source_timeout = 200;
  --     incomplete_delay = 400;
  --     max_abbr_width = 100;
  --     max_kind_width = 100;
  --     max_menu_width = 100;
  --     documentation = true;
  --
  --     source = {
  --       path = true;
  --       buffer = true;
  --       calc = true;
  --       vsnip = false;
  --       nvim_lsp = true;
  --       nvim_lua = true;
  --       spell = true;
  --       tags = true;
  --       snippets_nvim = false;
  --       treesitter = true;
  --     };
  --   }

  --   require 'lspkind'.init()
  --   require 'lspsaga'.init_lsp_saga()
  --
  --   -- Kommentary
  --   vim.api.nvim_set_keymap("n", "<leader>/", "<plug>kommentary_line_default", {})
  --   vim.api.nvim_set_keymap("v", "<leader>/", "<plug>kommentary_visual_default", {})
  --
  --   require 'formatter'.setup {
  --     filetype = {
  --       java = {
  --         function()
  --           return {
  --             exe = 'java',
  --             args = { '-jar', os.getenv('HOME') .. '/.local/jars/google-java-format.jar', vim.api.nvim_buf_get_name(0) },
  --             stdin = true
  --           }
  --         end
  --       }
  --     }
  --   }
  --
  --   vim.api.nvim_exec([[
  --         augroup FormatAutogroup
  --           autocmd!
  --           autocmd BufWritePost *.java FormatWrite
  --         augroup end
  --       ]], true)

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }
  -- TODO: revisit these keymaps and make consistent with LspZero
  -- buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts) -- no implemented by jdtls
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap(
    'n',
    '<leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    opts
  )
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  -- Java specific
  buf_set_keymap('n', '<leader>di', "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
  buf_set_keymap('n', '<leader>dt', "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
  buf_set_keymap('n', '<leader>dn', "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
  buf_set_keymap(
    'v',
    '<leader>de',
    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    opts
  )
  buf_set_keymap('n', '<leader>de', "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
  buf_set_keymap('v', '<leader>dm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

  buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  -- vim.api.nvim_create_augroup("JavaLsp", { clear = true })
  -- vim.api.nvim_create_autocmd({ "CursorHold" }, {
  --   group = "JavaLsp",
  --   pattern = { "<buffer>" },
  --   callback = vim.lsp.buf.hover
  -- })
end
config['on_attach'] = on_attach

-- setup jars for debug and test runners
-- local jar_patterns = {

-- java 19 not compatible as of 12/20/22 https://github.com/eclipse-tycho/tycho/issues/958 fails on mvnw clean install
-- git clone git@github.com:microsoft/java-debug.git && cd java-debug
-- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME="$(dirname $(dirname $(readlink -f $(which mvn))))" ./mvnw clean install
--   '/Users/mike/gitrepos/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',

--   -- git clone git@github.com:dgileadi/vscode-java-decompiler.git
--   '/Users/mike/gitrepos/vscode-java-decompiler/server/*.jar',

-- git clone git@github.com:microsoft/vscode-java-test.git && cd vscode-java-test/java-extension
-- npm install
-- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME='/opt/homebrew/Cellar/maven/3.8.6' npm run build-plugin
-- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME="$(dirname $(dirname $(readlink -f $(which mvn))))" ./mvnw clean install

--   '/Users/mike/gitrepos/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar',
--   '/Users/mike/gitrepos/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar',
--   '/Users/mike/gitrepos/vscode-java-test/server/*.jar',

-- git clone git@github.com:testforstephen/vscode-pde.git && cd vscode-pde/pde/
-- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME="$(dirname $(dirname $(readlink -f $(which mvn))))" ./mvnw clean install
--   '/Users/mike/gitrepos/vscode-pde/pde/org.eclipse.jdt.ls.importer.pde/target/*.jar'
-- }

-- local bundles = {}
-- for _, jar_pattern in ipairs(jar_patterns) do
--   for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
--     if not vim.endswith(bundle, 'com.microsoft.java.test.runner-jar-with-dependencies.jar')
--         and not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
--       table.insert(bundles, bundle)
--     end
--   end
-- end

local bundles = {

  -- java 19 not compatible as of 12/20/22 https://github.com/eclipse-tycho/tycho/issues/958 fails on mvnw clean install
  -- git clone git@github.com:microsoft/java-debug.git && cd java-debug
  -- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME="$(dirname $(dirname $(readlink -f $(which mvn))))" ./mvnw clean install
  vim.fn.glob(
    '/Users/mike/gitrepos/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
    1
  ),
  '\n',
}

-- git clone git@github.com:dgileadi/vscode-java-decompiler.git
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob('/Users/mike/gitrepos/vscode-java-decompiler/server/*.jar', 1), '\n')
)

-- git clone git@github.com:microsoft/vscode-java-test.git && cd vscode-java-test/java-extension
-- npm install
-- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME='/opt/homebrew/Cellar/maven/3.8.6' npm run build-plugin
-- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME="$(dirname $(dirname $(readlink -f $(which mvn))))" ./mvnw clean install
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob('/Users/mike/gitrepos/vscode-java-test/server/*.jar', 1), '\n')
)

-- git clone git@github.com:testforstephen/vscode-pde.git && cd vscode-pde/pde/
-- JAVA_HOME="$(/usr/libexec/java_home -F -v 18)" M2_HOME="$(dirname $(dirname $(readlink -f $(which mvn))))" ./mvnw clean install
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(
      '/Users/mike/gitrepos/vscode-pde/pde/org.eclipse.jdt.ls.importer.pde/target/*.jar',
      1
    ),
    '\n'
  )
)

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
  bundles = bundles,
  extendedClientCapabilities = extendedClientCapabilities,
}

jdtls.start_or_attach(config)
