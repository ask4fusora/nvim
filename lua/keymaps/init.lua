vim.keymap.set("n", "<ESC>", function() vim.cmd.noh() end, { silent = true })

vim.keymap.set("", "<C-s>", function() vim.cmd.update() end, { silent = true })

vim.keymap.set("n", "] ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line("."), { "" }) end end)
vim.keymap.set("n", "[ ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line(".") - 1, { "" }) end end)

vim.keymap.set("", "<M-F>", function() vim.lsp.buf.format({ async = true }) end)
