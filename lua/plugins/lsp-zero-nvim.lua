return {
  'VonHeikemen/lsp-zero.nvim',
  enabled = true,
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lua' },

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },


    { 'rcarriga/nvim-dap-ui' },
    { "mfussenegger/nvim-dap" },
    { "folke/neodev.nvim" },

  },
  config = function()
    local status, neodev = pcall(require, "neodev")
    if not status then
      vim.cmd.echom("error")
      return
    end
    local lsp
    status, lsp = pcall(require, "lsp-zero")
    if not status then
      vim.cmd.echom("error")
      return
    end
    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    neodev.setup({
      -- add any options here, or leave empty to use the default settings
      library = { plugins = { "nvim-dap-ui" }, types = true },
    })

    -- lsp.preset("recommended")
    lsp.set_preferences({
      suggest_lsp_servers = false,
      setup_servers_on_start = true,
      set_lsp_keymaps = true,
      configure_diagnostics = true,
      cmp_capabilities = true,
      manage_nvim_cmp = true,
      call_servers = 'local',
      sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
      }
    })

    -- lsp servers are available at the below path
    -- lua print(vim.fn.stdpath('data') .. '/site/pack/packer/start/nvim-lspconfig/lua/lspconfig/server_configurations/')

    -- local lua_language_server = 'sumneko_lua' -- see https://github.com/sumneko/lua-language-server/wiki/Settings
    -- see https://github.com/sumneko/lua-language-server/wiki/Settings
    local lua_language_server = 'lua_ls'

    -- Do not use the java language server in this config, it is setup independently
    -- local java_language_server = 'nvim-jdtls' -- https://github.com/mfussenegger/nvim-jdtls
    -- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jdtls
    -- IMPORTANT: If you want all the features jdtls has to offer, nvim-jdtls is highly recommended.
    -- If all you need is diagnostics, completion, imports, gotos and formatting and some code actions
    -- you can keep reading here.

    lsp.ensure_installed({
      lua_language_server,
      "luau_lsp",
    })

    -- lsp.nvim_workspace()

    -- some information from :h lspconfig-all
    lsp.configure(lua_language_server, {
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
            callSnippet = "Both",
            displayContext = 5,
            enable = true,
            keywordSnippet = "Both",
            postfix = '@',
            requireSeparator = '.',
            showParams = true,
            showWord = "Enable",
            workspaceWord = true,
          },
          {
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
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
            arrayIndex = "Enable",
            await = true,
            enable = true,
            paramName = "All",
            paramType = true,
            semicolon = "SameLine",
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
          }
        },
      },
    })

    lsp.configure("pylsp", {
      root_dir = function(fname)
        local util = require'lspconfig.util'
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

    -- install via brew install bash-language-server or npm i -g bash-language-server
    lsp.configure("bashls", {})

    lsp.configure("yamlls", {
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

    lsp.setup()
  end
}
