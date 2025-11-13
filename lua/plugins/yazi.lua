vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/mikavilpas/yazi.nvim" },
})

local yazi = require("yazi")

vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    yazi.setup({
      open_for_directories = true,
    })
  end,
})

vim.keymap.set("n", "<leader>e", function() yazi.yazi() end)
