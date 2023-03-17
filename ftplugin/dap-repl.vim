" copied from https://github.com/mfussenegger/dotfiles/blob/d6d8ff6f9bb0b2880aef88f5d119b623bb96c17f/vim/.config/nvim/ftplugin/dap-repl.vim
" inoremap <buffer> <c-h> <esc><c-w>h
" inoremap <buffer> <c-j> <esc><c-w>j
" inoremap <buffer> <c-k> <esc><c-w>k
" inoremap <buffer> <c-l> <esc><c-w>l
"
" inoremap <buffer> <F5> <ESC>:lua require'dap'.continue(); vim.cmd('startinsert!')<CR>
" inoremap <buffer> <F10> <ESC>:lua require'dap'.step_over(); vim.cmd('startinsert!')<CR>
" inoremap <buffer> <F11> <ESC>:lua require'dap'.step_into(); vim.cmd('startinsert!')<CR>
" inoremap <buffer> <F12> <ESC>:lua require'dap'.step_out(); vim.cmd('startinsert!')<CR>

nnoremap <buffer> gF <c-w>sgF

setlocal nonumber norelativenumber cc=-1 nocuc

lua require('dap.ext.autocompl').attach()
