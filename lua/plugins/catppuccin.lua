vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
  auto_integrations = true,
  integrations = {
    fidget = true,
    telescope = { enabled = true },
    which_key = true
  }
})

vim.cmd.colorscheme("catppuccin")
