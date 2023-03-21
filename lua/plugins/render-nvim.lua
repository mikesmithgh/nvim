return {
  {
    "mikesmithgh/render.nvim",
    enabled = true,
    lazy = true,
    dev = true,
    init = function()
      require("render").setup(
        {
          features = {
            auto_open = false,
          },
          font = {
            faces = {
              {
                name = "MonaLisa Nerd Font Regular",
                src =
                [[url('/Users/mike/Library/Fonts/MonoLisa Regular Nerd Font.ttf') format("truetype")]]
              },
              {
                name = "MonaLisa Nerd Font Bold",
                src = [[url('/Users/mike/Library/Fonts/MonoLisa Bold Nerd Font.ttf') format("truetype")]]
              },
              {
                name = "MonaLisa Nerd Font Regular Italic",
                src =
                [[url('/Users/mike/Library/Fonts/MonoLisa Regular Italic Nerd Font.ttf') format("truetype")]]
              },
              {
                name = "MonaLisa Nerd Font Bold Italic",
                src =
                [[url('/Users/mike/Library/Fonts/MonoLisa Bold Italic Nerd Font.ttf') format("truetype")]]
              },
              {
                name = "MonoLisa Regular Nerd Font Complete Windows Compatible",
                src =
                [[url('/Users/mike/Library/Fonts/MonoLisa Regular Nerd Font Complete Windows Compatible.ttf') format("truetype")]]
              },
              {
                name = "MonoLisa Regular Nerd Font Complete Windows Compatible",
                src =
                [[url('/Users/mike/Library/Fonts/MonoLisa Regular Nerd Font Complete Windows Compatible.ttf') format("truetype")]]
              },
            },
            size = 18,
          },
        }
      )
    end,
  },
}
