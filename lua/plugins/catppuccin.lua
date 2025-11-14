vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
  auto_integrations = true,
  integrations = {
    fidget = true,
    telescope = { enabled = true },
  },

  custom_highlights = function(colors)
    return {}
  end
})

vim.cmd.colorscheme("catppuccin")
