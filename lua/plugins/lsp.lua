return {
  {
    'williamboman/mason.nvim',
    dependencies = {
      -- LSP Support
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',

      -- null-ls
      'jose-elias-alvarez/null-ls.nvim',
      'jay-babu/mason-null-ls.nvim',

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

      'folke/neodev.nvim',
    },
    enabled = true,
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
        },
      })

      -- TODO: look into the below command for importing all required packages
      -- require("mason.api.command").MasonInstall({'shfmt'}, {})

      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      require('neodev').setup({
        library = { plugins = { 'nvim-dap-ui' }, types = true },
      })
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
          'luau_lsp',
          'bashls',
        },
      })

      -- TODO: should this be moved?
      require('mason-nvim-dap').setup({
        ensure_installed = {
          'python',
          'delve',
          'bash',
        },
      })

      -- TODO: should this be moved?
      require('mason-null-ls').setup({
        ensure_installed = {
          'shfmt',
        },
      })

      -- copied from lsp zero
      require('nvim-cmp-setup').call_setup()
      local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lsp_attach = function(client, bufnr)
        -- Create your keybindings here...
      end

      -- require('lspconfig.ui.windows').default_options.border = require('style').border.thinblock

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
                  enable = true,
                  -- Put format options here
                  -- NOTE: the value should be STRING!!
                  -- defaultConfig = {
                  --   indent_style = "space",
                  --   indent_size = "2",
                  -- }
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
                {
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file('', true),
                  },
                },
                runtime = {
                  -- :lua print(jit.version)  =>  LuaJIT 2.1.0-beta3
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
              },
            },
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

      vim.fn.sign_define(
        'DiagnosticSignError',
        { texthl = 'DiagnosticSignError', text = '×', numhl = 'DiagnosticSignError' }
      )
      vim.fn.sign_define(
        'DiagnosticSignWarn',
        { texthl = 'DiagnosticSignWarn', text = '▲', numhl = '' }
      )
      vim.fn.sign_define(
        'DiagnosticSignHint',
        { texthl = 'DiagnosticSignHint', text = '⚑', numhl = '' }
      )
      vim.fn.sign_define(
        'DiagnosticSignInfo',
        { texthl = 'DiagnosticSignInfo', text = '', numhl = '' }
      )
    end,
  },
}
