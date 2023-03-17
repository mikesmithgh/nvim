return {
  'hrsh7th/nvim-cmp',
  enabled = true,
  config = function()
    -- If you want insert `(` after select function or method item
    local status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if not status then
      return
    end
    local cmp
    status, cmp = pcall(require, "cmp")
    if not status then
      return
    end
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

    -- cmp.setup {
    --
    -- }
  end
}
