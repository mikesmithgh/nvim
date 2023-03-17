return {
  "yanskun/gotests.nvim",
  ft = "go",
  enabled = true,
  config = function()
    require("gotests").setup()
  end,
}
