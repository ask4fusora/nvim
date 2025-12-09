vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

local treesitter_context = require('treesitter-context')

treesitter_context.setup({
  enable = true,
})

vim.keymap.set('n', '<leader>k', function() treesitter_context.go_to_context(vim.v.count1) end)
