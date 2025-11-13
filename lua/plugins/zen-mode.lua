vim.pack.add({
  { src = "https://github.com/folke/twilight.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim" }
})

local zen_mode_toggle = require("zen-mode").toggle

vim.keymap.set("n", "<C-w>f", function() zen_mode_toggle({ window = { width = 0.618 } }) end)
