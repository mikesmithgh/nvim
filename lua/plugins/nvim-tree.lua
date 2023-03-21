return {
  'nvim-tree/nvim-tree.lua',
  enabled = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  version = 'nightly',             -- optional, updated every week. (see issue #1193)
  config = function()
    local status, nvim_tree = pcall(require, "nvim-tree")
    if not status then
      return
    end
    M = {}

    M.toggle = true

    M.setup = function()
      M.toggle = not M.toggle
      -- TODO super hacked together, revisit this

      local my_mappings_list = {
        { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
        { key = "<C-e>",                          action = "edit_in_place" },
        { key = "O",                              action = "edit_no_picker" },
        { key = { "<C-]>", "<2-RightMouse>" },    action = "cd" },
        { key = "<C-v>",                          action = "vsplit" },
        { key = "<C-x>",                          action = "split" },
        { key = "<C-t>",                          action = "tabnew" },
        { key = "<",                              action = "prev_sibling" },
        { key = ">",                              action = "next_sibling" },
        { key = "P",                              action = "parent_node" },
        --      { key = "<BS>", action = "" }, -- disable <BS> because it is mapped to <C-w>
        { key = "<Tab>",                          action = "preview" },
        -- { key = "K", action = "first_sibling" }, -- do not need conflicts with toggle_file_info and angle brackets do this
        -- { key = "J", action = "last_sibling" },
        { key = "C",                              action = "toggle_git_clean" },
        { key = "I",                              action = "toggle_git_ignored" },
        { key = "H",                              action = "toggle_dotfiles" },
        { key = "B",                              action = "toggle_no_buffer" },
        { key = "U",                              action = "toggle_custom" },
        { key = "R",                              action = "refresh" },
        { key = "a",                              action = "create" },
        { key = "d",                              action = "remove" },
        { key = "D",                              action = "trash" },
        { key = "r",                              action = "rename" },
        { key = "<C-r>",                          action = "full_rename" },
        { key = "e",                              action = "rename_basename" },
        { key = "x",                              action = "cut" },
        { key = "c",                              action = "copy" },
        { key = "p",                              action = "paste" },
        { key = "y",                              action = "copy_name" },
        { key = "Y",                              action = "copy_path" },
        { key = "gy",                             action = "copy_absolute_path" },
        { key = "[e",                             action = "prev_diag_item" },
        { key = "[c",                             action = "prev_git_item" },
        { key = "]e",                             action = "next_diag_item" },
        { key = "]c",                             action = "next_git_item" },
        { key = "-",                              action = "dir_up" },
        --      { key = "s", action = "system_open" }, -- disable s because it is mapped as psuedo leader
        { key = "f",                              action = "live_filter" },
        { key = "F",                              action = "clear_live_filter" },
        { key = "q",                              action = "close" },
        { key = "W",                              action = "collapse_all" },
        { key = "E",                              action = "expand_all" },
        { key = "S",                              action = "search_node" },
        { key = ".",                              action = "run_file_command" },
        -- { key = "<C-k>", action = "toggle_file_info" },
        { key = "K",                              action = "toggle_file_info" },
        { key = "g?",                             action = "toggle_help" },
        { key = "m",                              action = "toggle_mark" },
        { key = "bmv",                            action = "bulk_move" },
        --   { key = "=", action = "resize to fit contents", action_cb = resizer }
      }
      local HEIGHT_RATIO = 0.8 -- You can change this
      local WIDTH_RATIO = 0.5  -- You can change this too


      local sidebar_options = {
        enable = false,
        quit_on_focus_loss = true,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 30,
          height = 30,
          row = 1,
          col = 1,
        },
      }

      local float_options = {
        enable = true,
        open_win_config = function()
          local screen_w = vim.opt.columns:get()
          local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
          local window_w = screen_w * WIDTH_RATIO
          local window_h = screen_h * HEIGHT_RATIO
          local window_w_int = math.floor(window_w)
          local window_h_int = math.floor(window_h)
          local center_x = (screen_w - window_w) / 2
          local center_y = ((vim.opt.lines:get() - window_h) / 2)
            - vim.opt.cmdheight:get()
          return {
            border = "none",
            relative = "editor",
            row = center_y,
            col = center_x,
            width = window_w_int,
            height = window_h_int,
          }
        end,
      }

      local function float_opt(float_enabled)
        if float_enabled then
          return float_options
        end
        return sidebar_options
      end

      local function width_opt(float_enabled)
        if float_enabled then
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end
        return 30
      end

      -- thanks https://github.com/MarioCarrion/videos/blob/main/2023/01/nvim/lua/plugins/nvim-tree.lua
      local nvim_tree_view = {
        adaptive_size = false,
        centralize_selection = false,
        width = width_opt(M.toggle),
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        mappings = {
          custom_only = true,
          list = my_mappings_list,
        },
        float = float_opt(M.toggle),
      }

      -- only applies when on sidebar, not floating
      local function resizer()
        vim.cmd([[NvimTreeToggle]])
        M.setup()
        vim.cmd([[NvimTreeToggle]])
        -- local view = require("nvim-tree.view")
        -- local float_enabled = not view.View.float
        --
        -- local v = vim.tbl_deep_extend("force", nvim_tree_view, {
        --   width = width_opt(float_enabled),
        --   float = float_opt(float_enabled),
        -- })
        -- view.close()
        --     .setup({
        --       view = v
        --     })
        -- -- view.resize(nvim_tree_view.width)
        -- -- nvim_tree_view.grow_from_content()
      end

      table.insert(nvim_tree_view.mappings.list,
        { key = "=", action = "toggle adaptive size", action_cb = resizer })
      local tree_opts = {
        auto_reload_on_write = true,
        create_in_closed_folder = false,
        disable_netrw = false,
        hijack_cursor = false,
        hijack_netrw = false, -- changed this
        hijack_unnamed_buffer_when_opening = false,
        ignore_buffer_on_setup = false,
        open_on_setup = false,
        open_on_setup_file = false,
        sort_by = "name",
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = false,
        reload_on_bufenter = false,
        respect_buf_cwd = true,
        on_attach = "disable",
        remove_keymaps = false,
        select_prompts = false,
        view = nvim_tree_view,
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = false,
          full_name = false,
          highlight_opened_files = "none",
          root_folder_label = ":~:s?$?/..?",
          indent_width = 2,
          indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              bookmark = "",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
          symlink_destination = true,
        },
        hijack_directories = {
          enable = false,
          auto_open = true,
        },
        update_focused_file = {
          enable = false,
          update_root = false,
          ignore_list = {},
        },
        ignore_ft_on_setup = {},
        system_open = {
          cmd = "",
          args = {},
        },
        diagnostics = {
          enable = false,
          show_on_dirs = false,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        filters = {
          dotfiles = false,
          custom = {},
          exclude = {},
        },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = {},
        },
        git = {
          enable = true,
          ignore = false,
          show_on_dirs = true,
          show_on_open_dirs = true,
          timeout = 400,
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "shadow",
              style = "minimal",
            },
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = false,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame",
                  "dapui_watches",
                  "dapui_stacks", "dapui_breakpoints", "dapui_scopes", "dapui_console", "dapui-repl" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
        trash = {
          cmd = "gio trash",
          require_confirm = true,
        },
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = true,
        },
        tab = {
          sync = {
            open = false,
            close = false,
            ignore = {},
          },
        },
        notify = {
          threshold = vim.log.levels.INFO,
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
        },
      }
      nvim_tree.setup(tree_opts)
    end

    M.setup()

    return M
  end
}
