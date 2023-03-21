local M = {}

local json_or_yaml = {
  priority = -math.huge,
  function(_, bufnr)
    if vim.fn.did_filetype() ~= 0 then
      -- Filetype was already detected
      return
    end
    local lines_table = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines_table, "\n")
    local is_yaml = vim.fn.match(content, '^---\\|\\s\\+\\w\\+:\\s*') >= 0
    if is_yaml then
      return "yaml"
    end
    local is_json = vim.fn.match(content, '^\\s*{.*}\\s*$') >= 0
    if is_json then
      return "json"
    end
  end
}

M.setup = function()
  vim.filetype.add{
    pattern = {
      ['.*.pipeline'] = json_or_yaml,
      ['%.releaserc'] = json_or_yaml,
      ['.*%.%d*T%d*%.bak'] = function(path, bufnr)
        -- my filename convention for backup files
        -- logic reference from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/filetype.lua#L1273
        local root = vim.fn.fnamemodify(path, ':r:r')
        return require("vim.filetype").match({ buf = bufnr, filename = root })
      end,
    },
  }
end

return M
