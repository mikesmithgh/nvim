return {
  'ibhagwan/fzf-lua',
  enabled = true,
  lazy = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
    'mikesmithgh/gruvsquirrel.nvim',
    'mikesmithgh/borderline.nvim',
  },
  event = 'VeryLazy',
  cmd = 'FzfLua',
  init = function()
    vim.fn.mkdir(vim.fn.stdpath('state') .. '/fzf-lua/', 'p')
  end,
  config = function()
    local actions = require('fzf-lua.actions')

    local global_fzf_opts = {
      -- options are sent as `<left>=<right>`
      -- set to `false` to remove a flag
      -- set to '' for a non-value flag
      -- for raw args use `fzf_args` instead
      ['--ansi'] = '',
      ['--preview-window'] = 'border-thinblock',
      ['--border'] = 'none',
      ['--margin'] = '0',
      ['--multi'] = '',
      ['--layout'] = 'reverse',
      ['--scroll-off'] = '7',
      ['--height'] = '100%',
      ['--cycle'] = '',
      ['--info'] = 'inline-right',
      -- ['--separator'] = '─',
      ['--scrollbar'] = '▊',
      ['--pointer'] = '󰅂',
      ['--no-separator'] = '',
      ['--marker'] = '﹢',
      ['--prompt'] = '$ ',
    }

    local ok, fzf_lua = pcall(require, 'gruvsquirrel.plugins.fzf-lua')
    if not ok then
      fzf_lua = require('fzf-lua')
    end
    fzf_lua.setup({
      -- custom devicons setup file to be loaded when `multiprocess = true`
      -- _devicons_setup = '~/gitrepos/gruvsquirrel.nvim/lua/gruvsquirrel/util/nvim-web-devicons-overrides.lua',

      -- fzf_bin         = 'sk',            -- use skim instead of fzf?
      -- https://github.com/lotabout/skim
      global_resume = true, -- enable global `resume`?
      -- can also be sent individually:
      -- `<any_function>.({ gl ... })`
      global_resume_query = true, -- include typed query in `resume`?
      winopts = {
        -- split         = "belowright new",-- open in a split instead?
        -- "belowright new"  : split below
        -- "aboveleft new"   : split above
        -- "belowright vnew" : split right
        -- "aboveleft vnew   : split left
        -- Only valid when using a float window
        -- (i.e. when 'split' is not defined, default)
        height = 0.90, -- window height
        width = 0.85, -- window width
        row = 0.4, -- window row position (0=top, 1=bottom)
        col = 0.5, -- window col position (0=left, 1=right)
        -- border argument passthrough to nvim_open_win(), also used
        -- to manually draw the border characters around the preview
        -- window, can be set to 'false' to remove all borders or to
        -- 'none', 'single', 'double', 'thicc' or 'rounded' (default)
        -- border     = 'double',
        -- border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        -- border = require('style').border.thinblock,
        fullscreen = false, -- start fullscreen?
        -- highlights should optimally be set by the colorscheme using
        -- FzfLuaXXX highlights. If your colorscheme doesn't set these
        -- or you wish to override its defaults use these:
        --[[ hl = {
              normal         = 'Normal',        -- window normal color (fg+bg)
              border         = 'FloatBorder',   -- border color
              help_normal    = 'Normal',        -- <F1> window normal
              help_border    = 'FloatBorder',   -- <F1> window border
              -- Only used with the builtin previewer:
              cursor         = 'Cursor',        -- cursor highlight (grep/LSP matches)
              cursorline     = 'CursorLine',    -- cursor line
              cursorlinenr   = 'CursorLineNr',  -- cursor line number
              search         = 'IncSearch',     -- search matches (ctags|help)
              title          = 'Normal',        -- preview border title (file/buffer)
              -- Only used with 'winopts.preview.scrollbar = 'float'
              scrollfloat_e  = 'PmenuSbar',     -- scrollbar "empty" section highlight
              scrollfloat_f  = 'PmenuThumb',    -- scrollbar "full" section highlight
              -- Only used with 'winopts.preview.scrollbar = 'border'
              scrollborder_e = 'FloatBorder',   -- scrollbar "empty" section highlight
              scrollborder_f = 'FloatBorder',   -- scrollbar "full" section highlight
            }, ]]
        preview = {
          -- default      = 'bat_async', -- override the default previewer?
          -- default uses the 'builtin' previewer
          border = 'border', -- border|noborder, applies only to native fzf previewers (bat/cat/git/etc)
          wrap = 'nowrap', -- wrap|nowrap
          hidden = 'nohidden', -- hidden|nohidden
          vertical = 'down:45%', -- up|down:size
          horizontal = 'right:60%', -- right|left:size
          layout = 'flex', -- horizontal|vertical|flex
          flip_columns = 120, -- #cols to switch to horizontal on flex
          -- Only used with the builtin previewer:
          title = true, -- preview border title (file/buf)?
          title_pos = 'center', -- left|center|right, title alignment
          scrollbar = 'float', -- `false` or string:'float|border'
          -- float:  in-window floating border
          -- border: in-border chars (see below)
          scrolloff = '-2', -- float scrollbar offset from right applies only when scrollbar = 'float'
          scrollchars = { '█', '' }, -- scrollbar chars ({ <full>, <empty> } applies only when scrollbar = 'border'
          delay = 50, -- delay(ms) displaying the preview prevents lag on fast scrolling
          winopts = {
            -- builtin previewer window options
            number = true,
            relativenumber = false,
            cursorline = true,
            cursorlineopt = 'both',
            cursorcolumn = false,
            signcolumn = 'no',
            list = false,
            foldenable = false,
            foldmethod = 'manual',
            -- winhighlight   = 'Normal:NvimInternalError'
          },
        },
        on_create = function()
          -- map esc to ctrl-z which is mapped to abort
          vim.api.nvim_buf_set_keymap(0, 't', '<esc>', '<c-z>', { silent = true, noremap = true })
          vim.api.nvim_buf_set_keymap(0, 't', '<c-j>', '<down><down><down><down><down>', { silent = true, noremap = true })
          vim.api.nvim_buf_set_keymap(0, 't', '<c-k>', '<up><up><up><up><up>', { silent = true, noremap = true })
        end,
      },
      keymap = {
        -- These override the default tables completely
        -- no need to set to `false` to disable a bind
        -- delete or modify is sufficient
        builtin = {
          -- neovim `:tmap` mappings for the fzf win
          ['<F1>'] = 'toggle-help',
          ['<F2>'] = 'toggle-fullscreen',
          -- Only valid with the 'builtin' previewer
          ['<F3>'] = 'toggle-preview-wrap',
          ['<F4>'] = 'toggle-preview',
          -- Rotate preview clockwise/counter-clockwise
          ['<F5>'] = 'toggle-preview-ccw',
          ['<F6>'] = 'toggle-preview-cw',
          ['<S-down>'] = 'preview-page-down',
          ['<S-up>'] = 'preview-page-up',
          ['<S-left>'] = 'preview-page-reset',
        },
        fzf = {
          -- fzf '--bind=' options
          ['ctrl-z'] = 'abort',
          ['ctrl-u'] = 'unix-line-discard',
          ['ctrl-f'] = 'half-page-down',
          ['ctrl-b'] = 'half-page-up',
          ['ctrl-a'] = 'beginning-of-line',
          ['ctrl-e'] = 'end-of-line',
          ['alt-a'] = 'toggle-all',
          -- Only valid with fzf previewers (bat/cat/git/etc)
          ['f3'] = 'toggle-preview-wrap',
          ['f4'] = 'toggle-preview',
          ['shift-down'] = 'preview-page-down',
          ['shift-up'] = 'preview-page-up',
        },
      },
      -- global fzf_opts
      -- fzf_opts = global_fzf_opts,
      -- fzf '--color=' options (optional)
      -- fzf_colors = function()
      --   return require('gruvsquirrel.plugins.fzf').fzf_colors()
      -- end,
      previewers = {
        cat = {
          cmd = 'cat',
          args = '--number',
        },
        bat = {
          cmd = 'bat',
          args = '--style=numbers,changes --color always',
          -- theme = 'boxsquirrel', -- bat preview theme (bat --list-themes)
          config = nil, -- nil uses $BAT_CONFIG_PATH
        },
        head = {
          cmd = 'head',
          args = nil,
        },
        git_diff = {
          cmd_deleted = 'git diff --color HEAD --',
          cmd_modified = 'git diff --color HEAD',
          cmd_untracked = 'git diff --color --no-index /dev/null',
          -- uncomment if you wish to use git-delta as pager
          -- can also be set under 'git.status.preview_pager'
          -- pager        = "delta --width=$FZF_PREVIEW_COLUMNS",
        },
        man = {
          -- NOTE: remove the `-c` flag when using man-db
          -- cmd = 'man -c %s | col -bx',
        },
        builtin = {
          syntax = true, -- preview syntax highlight?
          syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
          syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
          limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
          -- preview extensions using a custom shell command:
          -- for example, use `viu` for image previews
          -- will do nothing if `viu` isn't executable
          extensions = {
            -- neovim terminal only supports `viu` block output
            ['png'] = { 'chafa' },
            ['jpg'] = { 'chafa' },
          },
          -- if using `ueberzug` in the above extensions map
          -- set the default image scaler, possible scalers:
          --   false (none), "crop", "distort", "fit_contain",
          --   "contain", "forced_cover", "cover"
          -- https://github.com/seebye/ueberzug
          ueberzug_scaler = 'cover',
        },
      },
      -- provider setup
      files = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/files-history.txt',
        }),
        -- previewer    = 'bat', -- uncomment to override previewer
        -- (name from 'previewers' table)
        -- set to 'false' to disable
        prompt = 'Files󰅂 ',
        multiprocess = true, -- run command in a separate process
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        -- path_shorten   = 1,              -- 'true' or number, shorten path?
        -- executed command priority is 'cmd' (if exists)
        -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
        -- default options are controlled by 'fd|rg|find|_opts'
        -- NOTE: 'find -printf' requires GNU find
        -- cmd =
        -- [[ fd --color=never --type f --hidden --follow --no-ignore --exclude node_modules --exclude .worktrees --exclude .git --exclude '**/target/*classes/**' ]],

        -- see ~/.config/fd/ignore for ignored files
        -- cmd = [[ fd --color=never --type f --hidden --follow ]],
        -- fd_opts = [[ --color=never --type f]],
        fd_opts = [[--color=never --type f --type l]],

        -- find_opts    = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        -- rg_opts      = "--color=never --files --hidden --follow -g '!.git'",
        -- fd_opts      = '--color=never --type f --hidden --follow --exclude .git',
        toggle_ignore_flag = '--no-ignore', -- flag toggled in `actions.toggle_ignore`
        toggle_hidden_flag = '--hidden', -- flag toggled in `actions.toggle_hidden`
        toggle_follow_flag = '--follow', -- flag toggled in `actions.toggle_follow`
        hidden = true, -- enable hidden files by default
        follow = true, -- do not follow symlinks by default
        no_ignore = false, -- respect ".gitignore"  by default
      },
      git = {
        files = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/git-files-history.txt',
          }),
          prompt = 'GitFiles󰅂 ',
          cmd = 'git ls-files --exclude-standard',
          multiprocess = true, -- run command in a separate process
          git_icons = true, -- show git icons?
          file_icons = true, -- show file icons?
          color_icons = true, -- colorize file|git icons
          -- force display the cwd header line regardles of your current working
          -- directory can also be used to hide the header when not wanted
          -- show_cwd_header = true
        },
        status = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/git-status-history.txt',
          }),
          prompt = 'GitStatus󰅂 ',
          -- consider using `git status -su` if you wish to see
          -- untracked files individually under their subfolders
          cmd = 'git status -s',
          file_icons = true,
          git_icons = true,
          color_icons = true,
          previewer = 'git_diff',
          -- uncomment if you wish to use git-delta as pager
          --preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
          actions = {
            -- actions inherit from 'actions.files' and merge
            ['right'] = { actions.git_unstage, actions.resume },
            ['left'] = { actions.git_stage, actions.resume },
          },
        },
        commits = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/git-commits-history.txt',
          }),
          prompt = 'Commits󰅂 ',
          cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
          preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
          -- uncomment if you wish to use git-delta as pager
          --preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
          actions = {
            ['default'] = actions.git_checkout,
          },
        },
        bcommits = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/git-bcommits-history.txt',
          }),
          prompt = 'BCommits󰅂 ',
          -- default preview shows a git diff vs the previous commit
          -- if you prefer to see the entire commit you can use:
          --   git show --color {1} --rotate-to=<file>
          --   {1}    : commit SHA (fzf field index expression)
          --   <file> : filepath placement within the commands
          cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset' <file>",
          preview = 'git diff --color {1}~1 {1} -- <file>',
          -- uncomment if you wish to use git-delta as pager
          --preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
          actions = {
            ['default'] = actions.git_buf_edit,
            ['ctrl-s'] = actions.git_buf_split,
            ['ctrl-v'] = actions.git_buf_vsplit,
            ['ctrl-t'] = actions.git_buf_tabedit,
          },
        },
        branches = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/git-branches-history.txt',
          }),
          prompt = 'Branches󰅂 ',
          cmd = 'git branch --all --color',
          preview = 'git log --graph --pretty=oneline --abbrev-commit --color {1}',
          actions = {
            ['default'] = actions.git_switch,
          },
        },
        tags = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/git-tags-history.txt',
          }),
          prompt = 'Tags󰅂 ',
        },
        stash = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/git-stash-history.txt',
            ['--no-multi'] = '',
            ['--delimiter'] = "'[:]'",
          }),
          prompt = 'Stash󰅂 ',
          cmd = 'git --no-pager stash list',
          preview = 'git --no-pager stash show --patch --color {1}',
          actions = {
            ['default'] = actions.git_stash_apply,
            ['ctrl-x'] = { actions.git_stash_drop, actions.resume },
          },
        },
        icons = {
          ['M'] = { icon = 'M', color = 'yellow' },
          ['D'] = { icon = 'D', color = 'red' },
          ['A'] = { icon = 'A', color = 'green' },
          ['R'] = { icon = 'R', color = 'yellow' },
          ['C'] = { icon = 'C', color = 'yellow' },
          ['T'] = { icon = 'T', color = 'magenta' },
          ['?'] = { icon = '?', color = 'magenta' },
          -- override git icons?
          -- ["M"]        = { icon = "★", color = "red" },
          -- ["D"]        = { icon = "✗", color = "red" },
          -- ["A"]        = { icon = "+", color = "green" },
        },
      },
      grep = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/grep-history.txt',
        }),
        debug = false,
        exec_empty_query = true,
        prompt = 'Rg󰅂 ',
        input_prompt = 'Grep For󰅂 ',
        multiprocess = true, -- run command in a separate process
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        -- prefer rg_opts over setting cmd explicitly because other commands (e.g., lgrep_curbuf) extend rg_opts
        rg_opts = [[--sort-files --column --line-number --no-heading --color=never --smart-case --hidden --max-columns=512 -g '!{.git,.worktrees,node_modules,.Trash}/']],
        -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
        -- search strings will be split using the 'glob_separator' and translated
        -- to '--iglob=' arguments, requires 'rg'
        -- can still be used when 'false' by calling 'live_grep_glob' directly
        rg_glob = false, -- default to glob parsing?
        glob_flag = '--iglob', -- for case sensitive globs use '--glob'
        glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
        -- advanced usage: for custom argument parsing define
        -- 'rg_glob_fn' to return a pair:
        --   first returned argument is the new search query
        --   second returned argument are addtional rg flags
        -- rg_glob_fn = function(query, opts)
        --   ...
        --   return new_query, flags
        -- end,
        actions = {
          -- actions inherit from 'actions.files' and merge
          -- this action toggles between 'grep' and 'live_grep'
          ['ctrl-g'] = { actions.grep_lgrep },
        },
        no_header = false, -- hide grep|cwd header?
        no_header_i = false, -- hide interactive header?
      },
      args = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/args-history.txt',
        }),
        prompt = 'Args󰅂 ',
        files_only = true,
        -- actions inherit from 'actions.files' and merge
        actions = { ['ctrl-x'] = { actions.arg_del, actions.resume } },
      },
      oldfiles = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/oldfiles-history.txt',
        }),
        prompt = 'History󰅂 ',
        cwd_only = false,
        stat_file = true, -- verify files exist on disk
        include_current_session = false, -- include bufs from current session
        file_ignore_patterns = { 'COMMIT_EDITMSG' },
      },
      buffers = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/buffers-history.txt',
        }),
        prompt = 'Buffers󰅂 ',
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        sort_lastused = true, -- sort buffers() by last used
        actions = { ['ctrl-x'] = { fn = actions.buf_del, reload = true } },
      },
      tabs = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/tabs-history.txt',
          -- hide tabnr
          ['--delimiter'] = '[\\):]',
          ['--with-nth'] = '2..',
        }),
        prompt = 'Tabs󰅂 ',
        tab_title = 'Tab',
        tab_marker = '<<',
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        actions = {
          -- actions inherit from 'actions.buffers' and merge
          ['default'] = actions.buf_switch,
          ['ctrl-x'] = { actions.buf_del, actions.resume },
        },
      },
      lines = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/lines-history.txt',
          -- do not include bufnr in fuzzy matching
          -- tiebreak by line no.
          ['--delimiter'] = '[\\]:]',
          ['--nth'] = '2..',
          ['--tiebreak'] = 'index',
        }),
        previewer = 'builtin', -- set to 'false' to disable
        prompt = 'Lines󰅂 ',
        show_unlisted = false, -- exclude 'help' buffers
        no_term_buffers = true, -- exclude 'term' buffers
        -- actions inherit from 'actions.buffers' and merge
        actions = {
          ['default'] = actions.buf_edit_or_qf,
          ['alt-q'] = actions.buf_sel_to_qf,
          ['alt-l'] = actions.buf_sel_to_ll,
        },
      },
      blines = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/blines-history.txt',
          -- hide filename, tiebreak by line no.
          ['--delimiter'] = '[\\]:]',
          ['--with-nth'] = '2..',
          ['--tiebreak'] = 'index',
        }),
        previewer = 'builtin', -- set to 'false' to disable
        prompt = 'BLines󰅂 ',
        show_unlisted = true, -- include 'help' buffers
        no_term_buffers = false, -- include 'term' buffers
        -- actions inherit from 'actions.buffers' and merge
        actions = {
          ['default'] = actions.buf_edit_or_qf,
          ['alt-q'] = actions.buf_sel_to_qf,
          ['alt-l'] = actions.buf_sel_to_ll,
        },
      },
      tags = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/tags-history.txt',
        }),
        prompt = 'Tags󰅂 ',
        ctags_file = 'tags',
        multiprocess = true,
        file_icons = true,
        git_icons = true,
        color_icons = true,
        -- 'tags_live_grep' options, `rg` prioritizes over `grep`
        rg_opts = '--no-heading --color=always --smart-case',
        grep_opts = '--color=auto --perl-regexp',
        actions = {
          -- actions inherit from 'actions.files' and merge
          -- this action toggles between 'grep' and 'live_grep'
          ['ctrl-g'] = { actions.grep_lgrep },
        },
        no_header = false, -- hide grep|cwd header?
        no_header_i = false, -- hide interactive header?
      },
      btags = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/btags-history.txt',
          ['--delimiter'] = '[\\]:]',
          ['--with-nth'] = '2..',
          ['--tiebreak'] = 'index',
        }),
        prompt = 'BTags󰅂 ',
        ctags_file = 'tags',
        ctags_autogen = false, -- dynamically generate ctags each call
        multiprocess = true,
        file_icons = true,
        git_icons = true,
        color_icons = true,
        rg_opts = '--no-heading --color=always',
        grep_opts = '--color=auto --perl-regexp',
        -- actions inherit from 'actions.files'
      },
      colorschemes = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/colorschemes-history.txt',
        }),
        prompt = 'Colorschemes󰅂 ',
        live_preview = true, -- apply the colorscheme on preview?
        actions = { ['default'] = actions.colorscheme },
        winopts = { height = 0.55, width = 0.30 },
        post_reset_cb = function()
          -- reset statusline highlights after
          -- a live_preview of the colorscheme
          -- require('feline').reset_highlights()
        end,
      },
      quickfix = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/quickfix-history.txt',
        }),
        file_icons = true,
        git_icons = true,
      },
      lsp = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/lsp--history.txt',
        }),
        prompt_postfix = '󰅂 ', -- will be appended to the LSP label
        -- to override use 'prompt' instead
        cwd_only = false, -- LSP/diagnostics for cwd only?
        async_or_timeout = 5000, -- timeout(ms) or 'true' for async calls
        file_icons = true,
        git_icons = false,
        -- settings for 'lsp_{document|workspace|lsp_live_workspace}_symbols'
        symbols = {
          fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
            ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/lsp-symbols-history.txt',
          }),
          async_or_timeout = true, -- symbols are async by default
          symbol_style = 1, -- style for document/workspace symbols
          -- false: disable,    1: icon+kind
          --     2: icon only,  3: kind only
          -- NOTE: icons are extracted from
          -- vim.lsp.protocol.CompletionItemKind
          -- colorize using nvim-cmp's CmpItemKindXXX highlights
          -- can also be set to 'TS' for treesitter highlights ('TSProperty', etc)
          -- or 'false' to disable highlighting
          symbol_hl_prefix = 'CmpItemKind',
          -- additional symbol formatting, works with or without style
          symbol_fmt = function(s)
            return '[' .. s .. ']'
          end,
        },
        code_actions = {
          -- fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          --   ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/lsp-code-actions-history.txt',
          -- }),
          previewer = 'codeaction_native',
          -- previewer = 'codeaction_native',
          preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit' --syntax-theme gruvsquirrel",
          prompt = 'Code Actions󰅂 ',
          -- ui_select = false, -- use 'vim.ui.select'?
          async_or_timeout = 5000,
          winopts = {
            -- row = 0.40,
            -- height = 0.60,
            -- width = 0.60,
            preview = {
              border = 'border-thinblock',
              layout = 'vertical',
              vertical = 'down:75%',
            },
          },
        },
      },
      diagnostics = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/diagnostics-history.txt',
        }),
        prompt = 'Diagnostics󰅂 ',
        cwd_only = false,
        file_icons = true,
        git_icons = false,
        diag_icons = true,
        icon_padding = '', -- add padding for wide diagnostics signs
        -- by default icons and highlights are extracted from 'DiagnosticSignXXX'
        -- and highlighted by a highlight group of the same name (which is usually
        -- set by your colorscheme, for more info see:
        --   :help DiagnosticSignHint'
        --   :help hl-DiagnosticSignHint'
        -- only uncomment below if you wish to override the signs/highlights
        -- define only text, texthl or both (':help sign_define()' for more info)
        -- signs = {
        --   ["Error"] = { text = "", texthl = "DiagnosticError" },
        --   ["Warn"]  = { text = "", texthl = "DiagnosticWarn" },
        --   ["Info"]  = { text = "", texthl = "DiagnosticInfo" },
        --   ["Hint"]  = { text = "", texthl = "DiagnosticHint" },
        -- },
        -- limit to specific severity, use either a string or num:
        --   1 or "hint"
        --   2 or "information"
        --   3 or "warning"
        --   4 or "error"
        -- severity_only:   keep any matching exact severity
        -- severity_limit:  keep any equal or more severe (lower)
        -- severity_bound:  keep any equal or less severe (higher)
      },
      helptags = {
        fzf_opts = vim.tbl_extend('force', global_fzf_opts, {
          ['--delimiter'] = '[ ]',
          ['--with-nth'] = '1',
          ['--history'] = vim.fn.stdpath('state') .. '/fzf-lua/helptags-history.txt',
        }),
        prompt = 'Help󰅂 ',
      },
      builtin = {
        prompt = 'Builtin󰅂 ',
      },
      autocmds = {
        prompt = 'Autocmds󰅂 ',
      },
      command_history = {
        prompt = 'Command History󰅂 ',
      },
      search_history = {
        prompt = 'Search History󰅂 ',
      },
      registers = {
        prompt = 'Registers󰅂 ',
      },
      keymaps = {
        prompt = 'Keymaps󰅂 ',
      },
      spell_suggest = {
        prompt = 'Spelling Suggestions󰅂 ',
      },
      filetypes = {
        prompt = 'Filetypes󰅂 ',
      },
      packadd = {
        prompt = 'packadd󰅂 ',
      },
      menus = {
        prompt = 'Menu󰅂 ',
      },
      tmux = {
        prompt = 'Tmux󰅂 ',
      },
      dap = {
        commands = {
          prompt = 'DAP Commands󰅂 ',
        },
        configurations = {
          prompt = 'DAP Configurations󰅂 ',
        },
        variables = {
          prompt = 'DAP Variables󰅂 ',
        },
        frames = {
          prompt = 'DAP Frames󰅂 ',
        },
        breakpoints = {
          prompt = 'DAP Breakpoints󰅂 ',
        },
      },
      changes = {
        prompt = 'Changes󰅂 ',
      },
      jumps = {
        prompt = 'Jumps󰅂 ',
      },
      marks = {
        prompt = 'Marks󰅂 ',
      },
      commands = {
        prompt = 'Commands󰅂 ',
      },
      highlights = {
        prompt = 'Highlights󰅂 ',
      },
      tagstack = {
        prompt = 'Tagstack󰅂 ',
      },
      -- uncomment to use the old help previewer which used a
      -- minimized help window to generate the help tag preview
      -- helptags = { previewer = "help_tags" },
      -- uncomment to use `man` command as native fzf previewer
      -- (instead of using a neovim floating window)
      -- manpages = { previewer = "man_native" },
      --
      -- optional override of file extension icon colors
      -- available colors (terminal):
      --    clear, bold, black, red, green, yellow
      --    blue, magenta, cyan, grey, dark_grey, white
      -- file_icon_colors    = {
      --   ["sh"] = "green", -- accepts hex codes
      -- },
      -- padding can help kitty term users with
      -- double-width icon rendering

      -- Added file_icon_padding so that kitty expands the icon to two character width
      file_icon_padding = ' ',
      -- uncomment if your terminal/font does not support unicode character
      -- 'EN SPACE' (U+2002), the below sets it to 'NBSP' (U+00A0) instead
      -- nbsp = '\xc2\xa0',
    })
    -- fzflua.register_ui_select({
    --   winopts = {
    --     height = 0.40, -- window height
    --     width = 0.65, -- window width
    --     row = 0.4, -- window row position (0=top, 1=bottom)
    --     col = 0.5, -- window col position (0=left, 1=right)
    --   },
    -- })
  end,
}
