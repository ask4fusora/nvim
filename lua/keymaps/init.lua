vim.keymap.set("n", "<ESC>", ":noh<CR>", { silent = true })

vim.keymap.set("", "<C-s>", ":update<CR>", { silent = true })

vim.keymap.set("n", "] ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line("."), { "" }) end end)
vim.keymap.set("n", "[ ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line(".") - 1, { "" }) end end)

vim.keymap.set("", "<M-F>", vim.lsp.buf.format)
