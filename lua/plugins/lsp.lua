return {
  {
    'williamboman/mason.nvim',
    dependencies = {
      -- LSP Support
      'neovim/nvim-lspconfig',
      'williamboman/mason-lspconfig.nvim',

      -- -- null-ls
      -- 'jose-elias-alvarez/null-ls.nvim',
      -- 'jay-babu/mason-null-ls.nvim',

      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-emoji',
      'onsails/lspkind.nvim',

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },

      -- DAP
      'mfussenegger/nvim-dap',
      'jay-babu/mason-nvim-dap.nvim',

      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      'folke/neodev.nvim',
    },
    enabled = true,
    lazy = false,
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
          pip = {
            upgrade_pip = true,
          },
        },
      })

      -- TODO: look into the below command for importing all required packages
      -- require("mason.api.command").MasonInstall({'shfmt'}, {})

      require('neogen').setup({
        snippet_engine = 'luasnip',
      })

      require('mason-lspconfig').setup({
        -- Do not use the java language server in this config, it is setup independently
        -- local java_language_server = 'nvim-jdtls' -- https://github.com/mfussenegger/nvim-jdtls
        -- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jdtls
        -- IMPORTANT: If you want all the features jdtls has to offer, nvim-jdtls is highly recommended.
        -- If all you need is diagnostics, completion, imports, gotos and formatting and some code actions
        -- you can keep reading here.
        ensure_installed = {
          'lua_ls',
          'bashls',
          'kotlin_language_server',
          'pylsp',
          'gopls',
        },
      })

      -- TODO: should this be moved?
      require('mason-nvim-dap').setup({
        automatic_installation = false,
        ensure_installed = {
          'python@1.6.7', -- 1.6.8 no available in pip
          'delve',
          'bash',
          'kotlin',
        },
      })

      -- require('mason-null-ls').setup({
      --   ensure_installed = {
      --     'yapf',
      --     'shfmt',
      --   },
      -- })

      -- copied from lsp zero
      require('nvim-cmp-setup').call_setup()
      local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lsp_attach = function(client, bufnr)
        local library = require('lspconfig').lua_ls.manager.config.settings.Lua.workspace.library
        vim.schedule_wrap(vim.print)(library)
        -- vim.schedule_wrap(vim.print)(client, bufnr)
        -- Create your keybindings here...
      end

      -- require('lspconfig.ui.windows').default_options.border = require('style').border.thinblock

      -- all plugins may not be loaded onto the runtime path due to lazy loading
      -- so lets get all the directories in lazy.vim plugins and combine with the runtime path
      local lazy_plugin_paths = vim.fs.find(function(name)
        return name == 'lua'
      end, { limit = math.huge, type = 'directory', path = vim.fn.stdpath('data') .. '/lazy' })
      local lua_libraries = vim.list_extend(lazy_plugin_paths, vim.api.nvim_get_runtime_file('lua', true))
      local hash = {}
      local lua_ls_workspace_library = {}
      for _, v in ipairs(lua_libraries) do
        if not hash[v] then
          lua_ls_workspace_library[#lua_ls_workspace_library + 1] = v -- you could print here instead of saving to result table if you wanted
          hash[v] = true
        end
      end

      local lspconfig = require('lspconfig')
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
          })
        end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup({
            filetypes = { 'lua' },
            settings = {
              Lua = {
                format = {
                  enable = false,
                },
                completion = {
                  autoRequire = true,
                  callSnippet = 'Both',
                  displayContext = 5,
                  enable = true,
                  keywordSnippet = 'Both',
                  postfix = '@',
                  requireSeparator = '.',
                  showParams = true,
                  showWord = 'Enable',
                  workspaceWord = true,
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = lua_ls_workspace_library,
                },
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
                },
                telemetry = {
                  enable = false,
                },
                diagnostics = {
                  globals = {
                    'vim',
                  },
                },
                hint = {
                  arrayIndex = 'Enable',
                  await = true,
                  enable = true,
                  paramName = 'All',
                  paramType = true,
                  semicolon = 'SameLine',
                  setType = true,
                },
                hover = {
                  enable = true,
                  enumsLimit = 10,
                  expandAlias = true,
                  previewFields = 50,
                  viewNumber = true,
                  viewStringMax = 1000,
                },
                codeLens = {
                  enable = true,
                },
              },
            },
          })
        end,
        ['pylsp'] = function()
          lspconfig.pylsp.setup({
            root_dir = function(fname)
              local util = require('lspconfig.util')
              local root_files = {
                'pyproject.toml',
                'setup.py',
                'setup.cfg',
                -- 'requirements.txt',
                'Pipfile',
              }
              return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
            end,
            settings = {
              pylsp = {
                plugins = {
                  autopep8 = {
                    enabled = false, -- conflicts with yapf
                  },
                  pycodestyle = {
                    enabled = true,
                  },
                  flake8 = {
                    enabled = false, -- conflicts with yapf
                  },
                  yapf = {
                    enabled = true,
                  },
                  mccabe = {
                    enabled = true,
                  },
                  pyflakes = {
                    enabled = true,
                  },
                },
              },
            },
          })
        end,
        ['yamlls'] = function()
          lspconfig.yamlls.setup({
            filetypes = { 'yaml', 'yaml.docker-compose', 'yml' },
            settings = {
              yaml = {
                format = {
                  enable = true,
                },
                schemaStore = {
                  enable = true,
                },
              },
            },
          })
        end,
        ['bashls'] = function()
          lspconfig.bashls.setup({
            filetypes = { 'sh', 'bash' },
            settings = {
              -- see https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
              bashIde = {
                backgroundAnalysisMaxFiles = 500,

                -- Glob pattern for finding and parsing shell script files in the workspace.
                -- Used by the background analysis features across files.

                -- Prevent recursive scanning which will cause issues when opening a file
                -- directly in the home directory (e.g. ~/foo.sh).
                --
                -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
                globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
                shellcheckArguments = '',
                logLevel = 'debug',
              },
            },
          })
        end,
        ['kotlin_language_server'] = function()
          local util = require('lspconfig.util')
          lspconfig.kotlin_language_server.setup({
            -- kotlin = {
            --   -- root_dir = function()
            --   --   vim.print('root dir here')
            --   --   util.root_pattern('settings.gradle', 'settings.gradle.kts')
            --   -- end
            -- },
          })
        end,
      })

      vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
        update_in_insert = true,
        signs = true,
        underline = true,
        float = {
          focusable = true,
          style = 'minimal',
          -- border = 'none',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      vim.fn.sign_define('DiagnosticSignError', { texthl = 'DiagnosticSignError', text = '×', numhl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { texthl = 'DiagnosticSignWarn', text = '▲', numhl = '' })
      vim.fn.sign_define('DiagnosticSignHint', { texthl = 'DiagnosticSignHint', text = '⚑', numhl = '' })
      vim.fn.sign_define('DiagnosticSignInfo', { texthl = 'DiagnosticSignInfo', text = '', numhl = '' })
    end,
  },
}
