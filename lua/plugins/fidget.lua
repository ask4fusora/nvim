vim.pack.add({ { src = "https://github.com/j-hui/fidget.nvim" } })

local fidget = require("fidget")

fidget.setup({})

vim.notify = fidget.notify
