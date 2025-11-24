vim.pack.add({ { src = 'https://github.com/justinmk/vim-sneak' } })

vim.keymap.set({ 'n', 'x', 'o' }, '<leader>s', '<Plug>Sneak_s')
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>S', '<Plug>Sneak_S')
