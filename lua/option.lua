local M = {}

M.setup = function()
  -- globals
  -- disable netrw at the very start of your init.lua (strongly advised) Nvimtree
  -- vim.g.loaded_netrw = 1
  -- vim.g.loaded_netrwPlugin = 1

  vim.o.shell = 'fish'

  vim.opt.hidden = true

  -- vim.opt.mouse = 'a'

  vim.opt.autoread = true

  -- backups
  vim.opt.backup = true
  vim.opt.writebackup = true
  vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup//' -- two trailing slashes replace all / with %
  vim.opt.backupcopy = 'yes'
  vim.opt.backupext = '.bak' -- IMPORTANT: autocommand will override this
  vim.opt.backupskip:append('COMMIT_EDITMSG')
  vim.opt.patchmode = '' -- no patch mode needed, autocommand will take versioned backups

  vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
  vim.opt.undofile = true

  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('Options', { clear = true }),
    pattern = { '*' },
    callback = vim.schedule_wrap(function()
      pcall(function()
        vim.o.scroll = 5
      end)
    end),
  })

  -- Set 7 lines visible above/below the cursor
  vim.opt.scrolloff = 7

  -- Ignore case when searching
  vim.opt.ignorecase = true

  -- Case sensitive when searching with at least one uppcase letter
  vim.opt.smartcase = true

  -- Highlight search results
  vim.opt.hlsearch = true

  -- Makes search act like search in modern browsers
  vim.opt.incsearch = true

  -- Always show current position
  vim.opt.ruler = true

  -- Configure backspace so it acts as it should act
  vim.opt.backspace = { 'eol', 'start', 'indent' }
  vim.opt.whichwrap:append('<,>,h,l')

  -- Show matching brackets when text indicator is over them
  vim.opt.showmatch = true

  -- Show hybrid line numbers, the current line is absolute line number and all other
  -- will be relative line numbers
  vim.opt.number = true
  vim.opt.relativenumber = false

  -- Turn on the Wild menu
  vim.opt.wildmenu = true
  vim.opt.wildmode = { 'longest:full', 'full' }

  -- Highlight current line
  vim.opt.cursorline = true
  vim.opt.cursorcolumn = true

  -- -- hide insert autocomplete messages and while scanning for completion items
  vim.tbl_extend('force', vim.opt.shortmess, { 'c', 'C' })
  -- -- enable spell check completion
  vim.tbl_extend('force', vim.opt.complete, { 'kspell' })

  -- Improve popup completion menu
  vim.opt.completeopt = { 'longest', 'menuone' }

  -- Whitespace characters
  vim.opt.listchars = {
    eol = '↲',
    tab = '▸\\ ',
    trail = '·',
    extends = '»',
    precedes = '«',
    space = '·',
  }

  -- Enables 24-bit color, i.e., 8*8*8=512 instead of 8-bit 256 color, see issue: https://github.com/morhetz/gruvbox/wiki/Terminal-specific#2-colors-are-off
  vim.opt.termguicolors = true

  -- Set utf8 as standard encoding and en_US as the standard language
  vim.opt.encoding = 'utf8'

  -- Use Unix as the standard file type
  vim.opt.fileformats = { 'unix', 'dos', 'mac' }

  -- => TextRelated
  -- Use spaces instead of tabs
  vim.opt.expandtab = true

  -- Be smart when using tabs ;)
  vim.opt.smarttab = true

  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2

  -- augroup TabStops
  --   autocmd FileType java setlocal shiftwidth=4 tabstop=4 softtabstop=4
  -- augroup end

  -- Auto indent
  vim.opt.autoindent = true
  -- Smart indent
  vim.opt.smartindent = true
  -- Disable wrap lines
  vim.opt.wrap = false

  -- disable show mode in favor of airline status line
  vim.opt.showmode = false

  -- show message for any line change, this help see the register info
  vim.opt.report = 0

  vim.opt.virtualedit = 'block'
  vim.opt.showcmd = true

  vim.opt.fillchars = {
    stl = ' ',
    stlnc = ' ',
    wbr = ' ',

    horiz = '🭹',
    horizup = '🭹',
    horizdown = '🭹',

    vert = '🮇',
    vertleft = ' ',
    vertright = ' ',
    verthoriz = '🭹',

    -- vert      = ' ',
    fold = '·',
    foldopen = '-',
    foldclose = '+',
    foldsep = '│',
    diff = '╱',
    msgsep = '▅',
    eob = '~',
    lastline = '@',
  }

  vim.g.github_enterprise_urls = {}

  -- disable auto insert of comment after <cr> or o O
  vim.opt.formatoptions = vim.opt.formatoptions - { 'r', 'o' }
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = vim.api.nvim_create_augroup('Comments', { clear = true }),
    pattern = { '*' },
    callback = function()
      vim.opt.formatoptions = vim.opt.formatoptions - { 'r', 'o' }
    end,
  })

  vim.opt.inccommand = 'nosplit'

  vim.opt.keywordprg = ':Woman'

  vim.opt.cmdheight = 0

  -- => Status line
  -- lualine will override these values
  vim.o.statusline = [[%#EndOfBuffer#%<~%=neovim btw ]]
  vim.o.laststatus = 3

  -- not using this, this gives better treesitter highlights for TODO, NOTE, ERROR but disables lua lang server highlights
  -- highlight priorities
  -- see https://github.com/NvChad/NvChad/issues/1907
  -- this lets treesitter take precedence over semantic tokens
  -- I am not sure if I want this long term
  -- vim.highlight.priorities.semantic_tokens = vim.highlight.priorities.treesitter - 1

  -- write noautocmd
  vim.cmd.cnoreabbrev('naw noautocmd w')
  vim.cmd.cnoreabbrev('naw! noautocmd w!')

  -- noop for :a and :i, I tend to type :a<CR> by accident
  vim.cmd.cnoreabbrev('a <Nop>')
  vim.cmd.cnoreabbrev('i <Nop>')

  vim.cmd.colorscheme('gruvsquirrel')
end

return M
