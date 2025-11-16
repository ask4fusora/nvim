vim.pack.add({ { src = "https://github.com/lewis6991/gitsigns.nvim" } })

local gitsigns = require("gitsigns")

gitsigns.setup()

vim.keymap.set("n", "<leader>gs", function() gitsigns.refresh() end)
