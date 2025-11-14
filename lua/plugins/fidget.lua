vim.pack.add({ { src = "https://github.com/j-hui/fidget.nvim" } })

local fidget = require("fidget")

fidget.setup({
  notification = {
    window = {
      winblend = 0,
      align = "top"
    }
  }
})

vim.notify = fidget.notify
