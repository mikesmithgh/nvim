-- improved keybindings
return {
  {
    'tpope/vim-unimpaired',
    enabled = true,
    config = function()
      vim.cmd([[
        " --- below copied from https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim
        function! s:StatuslineRefresh() abort
          let &l:readonly = &l:readonly
          return ''
        endfunction

        function! s:Toggle(op) abort
          call s:StatuslineRefresh()
          return eval('&'.a:op) ? 'no'.a:op : a:op
        endfunction

        function! s:option_map(letter, option, mode) abort
          exe 'nmap <script> <Plug>(unimpaired-enable)' .a:letter ':<C-U>'.a:mode.' '.a:option.'<C-R>=<SID>StatuslineRefresh()<CR><CR>'
          exe 'nmap <script> <Plug>(unimpaired-disable)'.a:letter ':<C-U>'.a:mode.' no'.a:option.'<C-R>=<SID>StatuslineRefresh()<CR><CR>'
          exe 'nmap <script> <Plug>(unimpaired-toggle)' .a:letter ':<C-U>'.a:mode.' <C-R>=<SID>Toggle("'.a:option.'")<CR><CR>'
        endfunction

        function! s:Map(...) abort
          let [mode, head, rhs; rest] = a:000
          let flags = get(rest, 0, '') . (rhs =~# '^<Plug>' ? '' : '<script>')
          let tail = ''
          let keys = get(g:, mode.'remap', {})
          if type(keys) == type({}) && !empty(keys)
            while !empty(head) && len(keys)
              if has_key(keys, head)
                let head = keys[head]
                if empty(head)
                  let head = '<skip>'
                endif
                break
              endif
              let tail = matchstr(head, '<[^<>]*>$\|.$') . tail
              let head = substitute(head, '<[^<>]*>$\|.$', '', '')
            endwhile
          endif
          if head !=# '<skip>' && empty(maparg(head.tail, mode))
            return mode.'map ' . flags . ' ' . head.tail . ' ' . rhs
          endif
          return ''
        endfunction
        " --- above copied from https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim

        " clobber cursorcolumn TODO: remap if I want it
        unmap <Plug>(unimpaired-disable)t
        unmap <Plug>(unimpaired-enable)t
        unmap <Plug>(unimpaired-toggle)t

        " unmap unwanted bindings
        unmap yo
        unmap yo<esc>
        unmap =s
        unmap <s
        unmap >s
        unmap =s<esc>
        unmap <s<esc>
        unmap >s<esc>


        " map preferred bindings
        exe s:Map('n', '<leader>o', '<Plug>(unimpaired-toggle)')
        " exe s:Map('n', '[o', '<Plug>(unimpaired-enable)')
        " exe s:Map('n', ']o', '<Plug>(unimpaired-disable)')
        exe s:Map('n', '<leader>o<Esc>', '<Nop>')
        " exe s:Map('n', '[o<Esc>', '<Nop>')
        " exe s:Map('n', ']o<Esc>', '<Nop>')
        " exe s:Map('n', '=s', '<Plug>(unimpaired-toggle)')
        " exe s:Map('n', '<s', '<Plug>(unimpaired-enable)')
        " exe s:Map('n', '>s', '<Plug>(unimpaired-disable)')
        " exe s:Map('n', '=s<Esc>', '<Nop>')
        " exe s:Map('n', '<s<Esc>', '<Nop>')
        " exe s:Map('n', '>s<Esc>', '<Nop>')

        call s:option_map('/', 'hlsearch', 'set')

        " exe s:Map('n', '<leader>ot', '<cmd>ToggleTerm<cr>')
        ]])
    end,
  },
  {
    'tpope/vim-repeat',
    enabled = true,
  },
  {
    'andymass/vim-matchup',
    enabled = true,
    config = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  },
  {
    "kylechui/nvim-surround",
    enabled = true,
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
}
