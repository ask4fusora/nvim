vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
  auto_integrations = true,
  integrations = {
    fidget = true,
    telescope = { enabled = true },
    barbar = true,
    dropbar = {
      enabled = true,
      color_mode = true,
    },
    treesitter_context = true,
    vim_sneak = true,
    nvim_surround = true,
    gitsigns = {
      enabled = true,
      transparent = true,
    },
    render_markdown = true,
  },

  transparent_background = true,

  custom_highlights = function(colors)
    return {
      -- barbar

      BufferCurrent = { bg = colors.base },
      BufferCurrentMod = { bg = colors.base },
      BufferCurrentWARN = { bg = colors.base, fg = colors.yellow },
      BufferCurrentERROR = { bg = colors.base, fg = colors.red },
      BufferInactive = { bg = colors.crust },
      BufferInactiveMod = { bg = colors.crust },
      BufferInactiveSign = { bg = colors.crust },
      BufferTabpageFill = { bg = colors.crust },

      -- vim-exchange

      ExchangeRegion = { bg = colors.surface1 },
    }
  end
})

vim.cmd.colorscheme("catppuccin")
