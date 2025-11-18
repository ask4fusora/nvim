require("plugins.catppuccin")

vim.defer_fn(
  function()
    require("plugins.lualine")
    require("plugins.fidget")
    require("plugins.telescope")
    require("plugins.nvim-treesitter")
    require("plugins.yazi")
    require("plugins.zen-mode")
    -- require("plugins.neoscroll")
    -- require("plugins.copilot")
    require("plugins.zeta")
    require("plugins.lspkind")
    require("plugins.mini-completion")
    require("plugins.gitsigns")
  end,
  1
)
