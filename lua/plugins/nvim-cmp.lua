return {
  'hrsh7th/nvim-cmp',
  enabled = true,
  lazy = true,
  dependencies = { 'windwp/nvim-autopairs' },
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    -- If you want insert `(` after select function or method item
    local npairs = require('nvim-autopairs')
    local Rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')

    local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    -- For each pair of brackets we will add another rule
    -- instead of:
    -- if true {|} -> if true {|
    --                }
    --
    --                |
    -- we get:
    -- if true {|} -> if true {|
    --                  |
    --                }
    for _, bracket in pairs(brackets) do
      npairs.add_rules({
        Rule(bracket[1], bracket[2]):replace_map_cr(function()
          return '<c-g>u<CR><CMD>normal! ====<up><CR><end>'
        end),
      })
    end

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
