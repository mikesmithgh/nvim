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
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',

      -- DAP
      'mfussenegger/nvim-dap',
      'jay-babu/mason-nvim-dap.nvim',

      -- IMPORTANT: make sure to setup neodev and neoconf BEFORE lspconfig
      'folke/neoconf.nvim',
      'folke/neodev.nvim',
    },
    enabled = true,
    lazy = true,
    event = 'VeryLazy',
    config = function()
      -- IMPORTANT: make sure to setup neodev and neoconf BEFORE lspconfig
      require('neoconf').setup()
      -- TODO: replace neodev with lazydev.nvim https://github.com/folke/lazydev.nvim
      require('neodev').setup({
        library = { plugins = { 'nvim-dap-ui' }, types = true },
      })

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
          'tsserver',
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
        -- if client.server_capabilities.inlayHintProvider then
        --   vim.lsp.inlay_hint.enable()
        -- end
      end

      local lspconfig = require('lspconfig')
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
          })
        end,
        ['gopls'] = function()
          -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
          -- and https://github.com/golang/tools/blob/master/gopls/doc/settings.md
          lspconfig.gopls.setup({
            on_attach = lsp_attach,
            filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
            settings = {
              gopls = {
                -- This setting is experimental and may be deleted.
                -- staticcheck enables additional analyses from staticcheck.io. These analyses are documented on Staticcheck's website.
                -- https://staticcheck.dev/docs/checks/
                staticcheck = true,
                hints = {
                  -- see https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
                  compositeLiteralFields = true,
                  constantValues = true,
                  parameterNames = true,
                },
              },
            },
          })
        end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup({
            on_attach = lsp_attach,
            filetypes = { 'lua' },
            settings = {
              ---@diagnostic disable-next-line: missing-fields
              Lua = {
                format = {
                  enable = false,
                  defaultConfig = {},
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
                ---@diagnostic disable-next-line: missing-fields
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                  },
                  -- Make the server aware of Neovim runtime files
                  -- library = vim.api.nvim_get_runtime_file('', true),
                },
                ---@diagnostic disable-next-line: missing-fields
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
                },
                telemetry = {
                  enable = false,
                },
                ---@diagnostic disable-next-line: missing-fields
                diagnostics = {
                  globals = {
                    'vim',
                  },
                },
                hint = {
                  -- see https://github.com/LuaLS/lua-language-server/wiki/Settings#hintenable
                  arrayIndex = 'Auto',
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
                  viewString = true,
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
            on_attach = lsp_attach,
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
              ---@diagnostic disable-next-line: missing-fields
              pylsp = {
                ---@diagnostic disable-next-line: missing-fields
                plugins = {
                  autopep8 = {
                    enabled = false, -- conflicts with yapf
                  },
                  ---@diagnostic disable-next-line: missing-fields
                  pycodestyle = {
                    enabled = true,
                  },
                  ---@diagnostic disable-next-line: missing-fields
                  flake8 = {
                    enabled = false, -- conflicts with yapf
                  },
                  ---@diagnostic disable-next-line: missing-fields
                  yapf = {
                    enabled = true,
                  },
                  ---@diagnostic disable-next-line: missing-fields
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
            on_attach = lsp_attach,
            filetypes = { 'yaml', 'yaml.docker-compose', 'yml' },
            ---@diagnostic disable-next-line: missing-fields
            settings = {
              ---@diagnostic disable-next-line: missing-fields
              yaml = {
                ---@diagnostic disable-next-line: missing-fields
                format = {
                  enable = true,
                },
                ---@diagnostic disable-next-line: missing-fields
                schemaStore = {
                  enable = true,
                },
              },
            },
          })
        end,
        ['bashls'] = function()
          lspconfig.bashls.setup({
            on_attach = lsp_attach,
            filetypes = { 'sh', 'bash' },
            settings = {
              -- see https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
              ---@diagnostic disable-next-line: missing-fields
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
          ---@diagnostic disable-next-line: missing-fields
          lspconfig.kotlin_language_server.setup({
            on_attach = lsp_attach,
            -- kotlin language server is still not in a place to use for dev
            autostart = false,
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
