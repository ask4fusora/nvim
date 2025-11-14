vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" }
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-S-P>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', 'g/', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '	', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n',
  '<leader>h',
  function() if vim.g.vimruntime then builtin.help_tags() end end,
  { desc = 'Telescope help tags' }
)
