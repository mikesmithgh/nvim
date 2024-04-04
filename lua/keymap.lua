local M = {}

M.init = function()
  -- leader key
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','
end

local function resize_nvim_tree()
  local status, nvim_tree_view = pcall(require, 'nvim-tree.view')
  if not status then
    return
  end
  local nvim_tree_winnr = nvim_tree_view.get_winnr()
  if nvim_tree_winnr then
    nvim_tree_view.resize(vim.fn.winwidth(nvim_tree_winnr))
  end
end

M.setup = function()
  vim.keymap.set('n', '<space>', '<nop>')

  -- pseudo leaders
  vim.keymap.set('n', 's', '<nop>') -- used by kemap.fzf
  vim.keymap.set('n', '<c-n>', '<nop>') -- used by NvimTree still in init.vim

  vim.keymap.set({ 'n', 'i', 't', 'v' }, '<c-w>o', '<cmd>ZenMode<cr>', { noremap = true, silent = true })
  vim.keymap.set({ 'n', 'i', 't', 'v' }, '<c-w><c-o>', '<cmd>ZenMode<cr>', { noremap = true, silent = true })

  -- prefer <C-f> over q:
  vim.keymap.set('n', 'q:', ':')

  -- enable hlsearch before search
  vim.keymap.set('n', '/', ':set hlsearch<cr>/')
  vim.keymap.set('n', '?', ':set hlsearch<cr>?')
  vim.keymap.set('n', '*', ':set hlsearch<cr>*')
  vim.keymap.set('n', '#', ':set hlsearch<cr>#')
  vim.keymap.set('n', 'g*', ':set hlsearch<cr>g*')
  vim.keymap.set('n', 'g#', ':set hlsearch<cr>g#')

  -- tasty keymaps modified from https://github.com/ThePrimeagen/init.lua/blob/bc8324fa1c31bd1bc81fb8a5dde684dffd324f84/lua/theprimeagen/remap.lua
  vim.keymap.set('n', 'J', 'mzJ`z')
  -- vim.keymap.set('n', '<C-d>', '<C-d>zz') -- I don't like these because you can't scroll on a single page
  -- vim.keymap.set('n', '<C-u>', '<C-u>zz') -- I don't like these because you can't scroll on a single page
  vim.keymap.set('n', '<C-o>', '<C-o>zz')
  vim.keymap.set('n', '<C-i>', '<C-i>zz')
  vim.keymap.set('n', '<C-t>', '<C-t>zz')
  vim.keymap.set('n', '<C-]>', '<C-]>zz')
  vim.keymap.set('n', ']c', ']czz')
  vim.keymap.set('n', '[c', '[czz')
  vim.keymap.set('n', 'do', 'do]czz')
  vim.keymap.set('n', 'n', 'nzzzv')
  vim.keymap.set('n', 'N', 'Nzzzv')
  vim.keymap.set('n', '<a-n>', 'j0nzzzv')
  vim.keymap.set('n', '<a-s-n>', '0Nzzzv')

  -- Show all diagnostics on current line in floating window

  vim.keymap.set({ 'n' }, '<Leader>d', vim.diagnostic.open_float, { noremap = true, silent = true })
  vim.keymap.set({ 'n' }, ']d', vim.diagnostic.goto_next, {})
  vim.keymap.set({ 'n' }, '[d', vim.diagnostic.goto_prev, {})

  -- black hole register "_
  vim.keymap.set('n', 'x', '"_x')

  -- yanks and puts
  vim.keymap.set({ 'v' }, 'p', '"_dP', {})
  vim.keymap.set({ 'v' }, 'P', '"_dP', {})

  vim.keymap.set({ 'v' }, '<leader>Y', '"+Y', {})
  vim.keymap.set({ 'v' }, '<leader>y', '"+y', {})
  vim.keymap.set({ 'v' }, '<leader>p', '"_d"+P', {})
  vim.keymap.set({ 'v' }, '<leader>P', '"_d"+P', {})

  vim.keymap.set({ 'n' }, '<leader>Y', '"+y$', {})
  vim.keymap.set({ 'n' }, '<leader>y', '"+y', {})
  vim.keymap.set({ 'n' }, '<leader>yy', '"+yy', {})
  vim.keymap.set({ 'n' }, '<leader>p', '"+p<CR>', {})
  vim.keymap.set({ 'n' }, '<leader>P', '"+P<CR>', {})

  -- todo zy and zp mappings

  -- TODO: make this a user command instead of map
  -- vim.api.nvim_set_keymap('c', 'w!!', 'w !sudo tee > /dev/null %', {})

  vim.keymap.set({ 'n' }, '<C-e>', '5<C-e>', {})
  vim.keymap.set({ 'n' }, '<C-y>', '5<C-y>', {})
  vim.keymap.set({ 'n' }, '<C-h>', '3h', {})
  vim.keymap.set({ 'n' }, '<C-j>', '5j', {})
  vim.keymap.set({ 'n' }, '<C-k>', '5k', {})
  vim.keymap.set({ 'n' }, '<C-l>', '3l', {})
  vim.keymap.set({ 'v' }, '<C-h>', '3h', {})
  vim.keymap.set({ 'v' }, '<C-j>', '5j', {})
  vim.keymap.set({ 'v' }, '<C-k>', '5k', {})
  vim.keymap.set({ 'v' }, '<C-l>', '3l', {})

  -- Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
  -- vim.keymap.set("n", "Q", "gq")

  vim.keymap.set({ 'n', 't', 'v' }, '<c-n>n', ':NvimTreeToggle<CR>', {})
  vim.keymap.set('n', '<C-n><C-n>', function()
    if vim.opt.filetype:get() == 'NvimTree' then
      vim.cmd('wincmd p')
    else
      vim.cmd('NvimTreeFindFile')
      vim.cmd('NvimTreeFocus')
    end
  end, {})
  vim.keymap.set({ 'n' }, '<c-n><C-q>', ':copen<CR>', {})
  vim.keymap.set({ 'n' }, '<c-n>q', ':cclose<CR>', {})
  vim.keymap.set({ 'n' }, '<c-n><C-l>', ':lopen<CR>', {})
  vim.keymap.set({ 'n' }, '<c-n>l', ':lclose<CR>', {})

  vim.keymap.set('t', '<c-w>', '<c-\\><c-n><c-w>')
  vim.keymap.set({ 't' }, '<c-w><c-o>', '<c-\\><c-n><cmd>ZenMode<CR>', {})
  vim.keymap.set({ 't' }, '<c-w>o', '<c-\\><c-n><cmd>ZenMode<CR>', {})

  vim.keymap.set('i', '<c-w>', '<esc><c-w>')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true }
  vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>lk', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)

  -- vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  -- use IncRename plugin instead of default lsp rename
  vim.keymap.set('n', '<leader>lr', ':IncRename ')

  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>lR', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>lf', function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)

  -- TODO: keep this until it conflicts
  vim.keymap.set('t', '<esc>', '<c-\\><c-n><esc>', { remap = true })
  -- Toggle
  vim.keymap.set('n', '<leader><leader>t', function()
    vim.cmd('ToggleTerm')
  end)
  vim.keymap.set('n', '<leader><leader>d', function()
    local status, dapui = pcall(require, 'dapui')
    if not status then
      return
    end
    local dapuiwindows
    status, dapuiwindows = pcall(require, 'dapui.windows')
    if next(dapuiwindows.layouts) == nil then
      dapui.setup()
    end

    dapui.toggle()
  end)
  vim.keymap.set({ 'n', 'v' }, '<leader><leader>n', function()
    vim.cmd('NvimTreeToggle')
  end)
  vim.keymap.set('n', '<leader><leader>v', function()
    if next(require('diffview.lib').views) == nil then
      vim.cmd('DiffviewOpen')
    else
      vim.cmd('DiffviewClose')
    end
  end)

  vim.api.nvim_create_user_command('DiffviewToggle', function()
    vim.schedule(function()
      if next(require('diffview.lib').views) == nil then
        vim.cmd('DiffviewOpen')
      else
        vim.cmd('DiffviewClose')
      end
    end)
  end, {})

  vim.keymap.set('n', '<leader><leader>u', function()
    vim.cmd('UndotreeToggle')
    vim.cmd('UndotreeFocus')
  end)
  vim.keymap.set('n', '<leader><leader>p', function()
    vim.cmd('TSPlaygroundToggle')
  end)
  vim.keymap.set('n', '<leader><leader>l', function()
    if vim.opt.filetype:get() == 'lazy' then
      vim.cmd('close')
    else
      vim.cmd('Lazy')
    end
  end)
  vim.keymap.set('n', '<leader><leader>c', function()
    vim.cmd('ColorizerToggle')
  end)

  -- all fzf-lua commands are wrapped in functions to avoid triggering nvim-web-devicons
  -- see https://github.com/nvim-tree/nvim-web-devicons/issues/355

  vim.keymap.set('n', 's<leader>', function()
    require('fzf-lua.cmd').load_command()
  end)
  vim.keymap.set('n', 'sa', function()
    require('fzf-lua').files({
      cmd = [[ fd --color=never --type f --hidden --no-ignore --follow ]],
    })
  end)
  vim.keymap.set('n', 'sf', function()
    require('fzf-lua').files()
  end)
  vim.keymap.set('n', 'sp', function()
    require('fzf-lua').git_files()
  end)
  vim.keymap.set('n', 'sg', function()
    require('fzf-lua').live_grep()
  end)
  vim.keymap.set('n', 's/', function()
    require('fzf-lua').lgrep_curbuf()
  end)
  vim.keymap.set('n', 's?', function()
    require('fzf-lua').spell_suggest()
  end)
  vim.keymap.set('n', 'sb', function()
    require('fzf-lua').buffers()
  end)
  vim.keymap.set('n', 'sh', function()
    require('fzf-lua').help_tags()
  end)
  vim.keymap.set('n', 'sr', function()
    require('fzf-lua').registers()
  end)
  vim.keymap.set('n', 'st', function()
    require('telescope.builtin').builtin()
  end)
  vim.keymap.set('n', 'sj', function()
    require('fzf-lua').jumps()
  end)
  vim.keymap.set('n', 'sc', function()
    require('fzf-lua').changes()
  end)
  vim.keymap.set('n', 's8', function()
    require('fzf-lua').grep_cword()
  end)
  vim.keymap.set('n', 's*', function()
    require('fzf-lua').grep_cWORD()
  end)
  vim.keymap.set('n', 'sl', function()
    require('fzf-lua').resume()
  end)
  vim.keymap.set('n', 'so', function()
    require('fzf-lua').oldfiles()
  end)
  vim.keymap.set('n', 's:', function()
    require('fzf-lua').commands()
  end)

  vim.keymap.set('n', 'su', '<Cmd>UrlView buffer bufnr=0<CR>', { desc = 'View buffer URLs' })

  vim.keymap.set('n', 'sT', function()
    require('fzf-lua').lsp_typedefs()
  end)
  vim.keymap.set('n', 'sR', function()
    require('fzf-lua').lsp_references()
  end)
  vim.keymap.set('n', 'sD', function()
    require('fzf-lua').lsp_definitions()
  end)
  vim.keymap.set('n', 'sE', function()
    require('fzf-lua').lsp_declarations()
  end)
  vim.keymap.set('n', 'sI', function()
    require('fzf-lua').lsp_implementations()
  end)
  vim.keymap.set('n', 'sS', function()
    require('fzf-lua').lsp_document_symbols()
  end)
  -- vim.keymap.set('n', 'sA', fzf.lsp_workspace_symbols)
  vim.keymap.set('n', 'sA', function()
    require('fzf-lua').lsp_live_workspace_symbols()
  end)
  vim.keymap.set('n', 'sC', function()
    require('fzf-lua').lsp_code_actions()
  end)
  -- vim.keymap.set('n', 'sI', fzf.lsp_incoming_calls)
  -- vim.keymap.set('n', 'sO', fzf.lsp_outgoing_calls)
  vim.keymap.set('n', 'sW', function()
    require('fzf-lua').diagnostics_document()
  end)
  vim.keymap.set('n', 'sQ', function()
    require('fzf-lua').diagnostics_workspace()
  end)
  -- vim.keymap.set('n', 'sW', fzf.lsp_workspace_diagnostics)

  vim.keymap.set('n', 'sdb', function()
    require('fzf-lua').dap_breakpoints()
  end)
  vim.keymap.set('n', 'sdf', function()
    require('fzf-lua').dap_frames()
  end)
  vim.keymap.set('n', 'sdc', function()
    require('fzf-lua').dap_commands()
  end)
  -- vim.keymap.set('n', 'sW', fzf.lsp_workspace_diagnostics)

  -- venn.nvim: enable or disable keymappings
  -- copied from https://github.com/jbyuki/venn.nvim
  function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == 'nil' then
      vim.b.venn_enabled = true
      vim.cmd([[setlocal ve=all]])
      -- draw a line on HJKL keystokes
      vim.api.nvim_buf_set_keymap(0, 'n', 'J', '<C-v>j:VBox<CR>', { noremap = true })
      vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<C-v>k:VBox<CR>', { noremap = true })
      vim.api.nvim_buf_set_keymap(0, 'n', 'L', '<C-v>l:VBox<CR>', { noremap = true })
      vim.api.nvim_buf_set_keymap(0, 'n', 'H', '<C-v>h:VBox<CR>', { noremap = true })
      -- draw a box by pressing "f" with visual selection
      vim.api.nvim_buf_set_keymap(0, 'v', 'f', ':VBox<CR>', { noremap = true })
    else
      vim.cmd([[setlocal ve=]])
      vim.cmd([[mapclear <buffer>]])
      vim.b.venn_enabled = nil
    end
  end

  -- toggle keymappings for venn using <leader>v
  vim.keymap.set({ 'n' }, '<leader>v', ':lua Toggle_venn()<CR>', {})

  -- local osv
  -- status, osv = pcall(require, 'osv')
  -- if status then
  --   vim.keymap.set('n', '<leader><f5>', function()
  --     osv.launch({ port = 8086 })
  --   end, { silent = true })
  -- end

  vim.keymap.set({ 'n', 'i', 't' }, '<c-w>h', function()
    vim.cmd.stopinsert()
    vim.schedule(function()
      require('smart-splits.api').move_cursor_left()
    end)
  end, { noremap = true, silent = true })
  vim.keymap.set({ 'n', 'i', 't' }, '<c-w>j', function()
    vim.cmd.stopinsert()
    vim.schedule(function()
      require('smart-splits.api').move_cursor_down()
      if vim.opt.filetype:get() == 'NvimTree' then
        vim.cmd('wincmd l')
      end
    end)
  end, { noremap = true, silent = true })
  vim.keymap.set({ 'n', 'i', 't' }, '<c-w>k', function()
    vim.cmd.stopinsert()
    vim.schedule(function()
      require('smart-splits.api').move_cursor_up()
      if vim.opt.filetype:get() == 'NvimTree' then
        vim.cmd('wincmd l')
      end
    end)
  end, { noremap = true, silent = true })
  vim.keymap.set({ 'n', 'i', 't' }, '<c-w>l', function()
    vim.cmd.stopinsert()
    vim.schedule(function()
      require('smart-splits.api').move_cursor_right()
    end)
  end, { noremap = true, silent = true })

  vim.keymap.set({ 'n', 'i', 't' }, '<a-left>', function()
    require('smart-splits.api').resize_left()
    resize_nvim_tree()
  end)
  vim.keymap.set({ 'n', 'i', 't' }, '<a-down>', function()
    require('smart-splits.api').resize_down()
    resize_nvim_tree()
  end)
  vim.keymap.set({ 'n', 'i', 't' }, '<a-up>', function()
    require('smart-splits.api').resize_up()
    resize_nvim_tree()
  end)
  vim.keymap.set({ 'n', 'i', 't' }, '<a-right>', function()
    require('smart-splits.api').resize_right()
    resize_nvim_tree()
  end)

  vim.keymap.set('n', '<leader>q', function()
    for _, ui in pairs(vim.api.nvim_list_uis()) do
      if ui.chan and not ui.stdout_tty then
        vim.fn.chanclose(ui.chan)
      end
    end
  end, { noremap = true })

  vim.keymap.set('n', '<tab>', function()
    if vim.o.buftype == 'quickfix' then
      vim.cmd.cnext()
      vim.cmd.wincmd('p')
    else
      return '<tab>'
    end
  end)
  vim.keymap.set('n', '<s-tab>', function()
    if vim.o.buftype == 'quickfix' then
      vim.cmd.cprevious()
      vim.cmd.wincmd('p')
    else
      return '<tab>'
    end
  end)

  -- surround nvim
  vim.keymap.set('n', 'S', '<Plug>(nvim-surround-normal)')
  vim.keymap.set('n', 'SS', '<Plug>(nvim-surround-normal-cur)')
  vim.keymap.set('n', 'Sc', '<Plug>(nvim-surround-change)')
  vim.keymap.set('n', 'Sd', '<Plug>(nvim-surround-delete)')
end

-- ideas
-- TODO: more pseudo leaders

-- TODO: ctrl enter, shift enter https://stackoverflow.com/questions/16359878/how-to-map-shift-enter/42461580#42461580

-- TODO: keys that a good candidates for remap, R, S

-- revisit this in the future when you have more time to play
--
-- vim.keymap.set('n', 'S',
--   function() vim.api.nvim_echo({ { "~ TODO: map S as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<bs>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <bs> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<s-bs>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <bs> as pseudo leader ~", "Comment" } }, false, {}) end)
-- -- vim.keymap.set('n', '<cr>', function() vim.api.nvim_echo({{"~ TODO: map <cr> as pseudo leader ~", "Comment"}}, false, {}) end) -- conflicts with enter in q: mode
-- vim.keymap.set('n', '<left>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <left> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<up>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <up> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<right>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <right> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<down>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <down> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<del>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <del> as pseudo leader ~", "Comment" } }, false, {}) end)
-- -- vim.keymap.set('n', '<tab>', function() vim.api.nvim_echo({{"~ TODO: map <tab> as pseudo leader ~", "Comment"}}, false, {}) end) -- conflicts with <c-i>
-- vim.keymap.set('n', '<s-tab>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <s-tab> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<home>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <home> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<end>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <end> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '+',
--   function() vim.api.nvim_echo({ { "~ TODO: map + as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '-',
--   function() vim.api.nvim_echo({ { "~ TODO: map - as pseudo leader ~", "Comment" } }, false, {}) end)
-- -- vim.keymap.set('n', '<c-m>', function() vim.api.nvim_echo({{"~ TODO: map <c-m> as pseudo leader ~", "Comment"}}, false, {}) end) -- conflicts with enter in q: mode
-- vim.keymap.set('n', '<c-p>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <c-p> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<c-end>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <c-end> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<c-home>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <c-home> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<s-left>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <s-left> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<s-up>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <s-up> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<s-right>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <s-right> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<s-down>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <s-down> as pseudo leader ~", "Comment" } }, false, {}) end)
-- -- vim.keymap.set('n', '<w>', function() vim.api.nvim_echo({{"~ TODO: map <w> as pseudo leader ~", "Comment"}}, false, {}) end)
-- -- vim.keymap.set('n', '<w>', function() vim.api.nvim_echo({{"~ TODO: map <w> as pseudo leader ~", "Comment"}}, false, {}) end)
-- -- vim.keymap.set('n', '<w>', function() vim.api.nvim_echo({{"~ TODO: map <w> as pseudo leader ~", "Comment"}}, false, {}) end)
-- -- vim.keymap.set('n', '<w>', function() vim.api.nvim_echo({{"~ TODO: map <w> as pseudo leader ~", "Comment"}}, false, {}) end)
-- -- vim.keymap.set('n', '<w>', function() vim.api.nvim_echo({{"~ TODO: map <w> as pseudo leader ~", "Comment"}}, false, {}) end)
-- -- alt keys are up for grabs
-- vim.keymap.set('n', '<a-down>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <a-down> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<a-j>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <a-j> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<c-a-j>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <c-a-j> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<s-c-j>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <s-c-j> as pseudo leader ~", "Comment" } }, false, {}) end)
--
-- -- fn keys
-- -- macos > f11 disable mission control > show desktop binding to f11
-- vim.keymap.set('n', '<f11>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <f11> as pseudo leader ~", "Comment" } }, false, {}) end)
-- vim.keymap.set('n', '<fn>',
--   function() vim.api.nvim_echo({ { "~ TODO: map <fn> as pseudo leader ~", "Comment" } }, false, {}) end)
-- -- fn globe key on mac?

return M
