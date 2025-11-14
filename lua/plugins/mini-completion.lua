vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.completion" }
})

local mini_completion = require("mini.completion")

mini_completion.setup({
  lsp_completion = {
    source_func = "omnifunc"
  },
  mappings = {
    scroll_down = "<C-d>",
    scroll_up = "<C-u>"
  }
})
