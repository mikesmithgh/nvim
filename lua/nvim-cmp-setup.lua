local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Insert }

-- copied from lsp-zero to help me migrate
local M = {}
local s = {
  check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return true
    else
      return false
    end
  end
}

local function sources()
  local result = {}
  local register = function(mod, value)
    local pattern = string.format('lua/%s*', mod)
    local path = vim.api.nvim_get_runtime_file(pattern, false)

    if #path > 0 then
      table.insert(result, value)
    end
  end

  register('cmp_path', { name = 'path', keyword_length = 3 })
  register('cmp_nvim_lsp', { name = 'nvim_lsp' })
  register('cmp_buffer', { name = 'buffer', keyword_length = 3 })
  register('cmp_luasnip', { name = 'luasnip', keyword_length = 2 })
  register('cmp_nvim_lua', { name = 'nvim_lua', keyword_length = 3 }) -- may not need, lsp seems to be handling this

  return result
end

local opts = {
  enabled = true,
  -- performance = ???
  completion = {
    -- autocomplete = true,
    completeopt = 'menu,menuone,noinsert'
  },
  window = {
    documentation = {
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', },
      winhighlight = 'CursorLine:PmenuSel,Search:None',
      scrolloff = 3,
      col_offset = 1,
      max_height = 15,
      max_width = 60,
    },
    completion = {
      border = 'none',
      scrollbar = true,
      winhighlight = 'CursorLine:PmenuSel,Search:None',
      scrolloff = 3,
      col_offset = 0,
    },
  },
  -- confirmation = ???
  -- matching = ???
  -- sorting = ???
  formatting = {
    fields = { 'abbr', 'menu', 'kind' },
    format = require('lspkind').cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      menu = {
        nvim_lsp = '󰅩',
        nvim_lua = '',
        buffer = '',
        luasnip = '󰆑',
        latex_symbols = '󱗆',
        path = '󰿟',
        cmdline = '󰅂',
      },
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      -- The function below will be called before any actual modifications from lspkind so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      -- before = function(entry, vim_item)
      --   return vim_item
      -- end
    })
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    -- confirm selection
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-y>'] = cmp.mapping.confirm({ select = false }),
    -- navigate items on the list
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
    -- scroll up and down in the completion documentation
    ['<C-f>'] = cmp.mapping.scroll_docs(5),
    ['<C-u>'] = cmp.mapping.scroll_docs(-5),
    -- toggle completion
    ['<C-e>'] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end),
    -- when menu is visible, navigate to next item
    -- when line is empty, insert a tab character
    -- else, activate completion
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif s.check_back_space() then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    -- when menu is visible, navigate to previous item on list
    -- else, revert to default behavior
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ count = 5, behavior = select_opts.behavior })
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ count = 5, behavior = select_opts.behavior })
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<Esc>'] = cmp.mapping(function(_)
      local cmp_is_visible = cmp.core.view:visible()
      local leave_insert_mode = not cmp_is_visible
      if cmp_is_visible then
        local e = cmp.core.view:get_selected_entry()
        local is_active = cmp.core.view.custom_entries_view.active
        leave_insert_mode = e == nil or not is_active
        if not leave_insert_mode then
          cmp.core.view.custom_entries_view:_select(0, select_opts)
        end
      end
      if leave_insert_mode then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'i', true)
      end
    end, { 'i', 's' }),
    -- go to next placeholder in the snippet
    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = sources(),
  -- -- view = ???,
  experimental = {
    ghost_text = false -- this feature conflict with copilot.vim's preview.
  }
}

M.call_setup = function()
  cmp.setup(opts)
end


return M
