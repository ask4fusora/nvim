vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
  auto_integrations = true,
  integrations = {
    fidget = true,
    telescope = { enabled = true },
    which_key = true,
    barbar = true
  },

  custom_highlights = function(colors)
    return {
      -- barbar

      BufferCurrent = { bg = colors.base },
      BufferCurrentMod = { bg = colors.base },
      BufferInactive = { bg = colors.crust },
      BufferInactiveMod = { bg = colors.crust },
      BufferInactiveSign = { bg = colors.crust },
      BufferTabpageFill = { bg = colors.crust }
    }
  end
})

vim.cmd.colorscheme("catppuccin")
