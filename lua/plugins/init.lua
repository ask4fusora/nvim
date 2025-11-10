vim.pack.add({
  { src = "https://github.com/catppuccin/nvim",                 name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
})

require("plugins.catppuccin")
require("plugins.nvim-treesitter")
