vim.keymap.set("n", "<ESC>", function() vim.cmd.noh() end, { silent = true })

vim.keymap.set("", "<C-s>", function() vim.cmd.update() end, { silent = true })

vim.keymap.set("n", "] ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line("."), { "" }) end end)
vim.keymap.set("n", "[ ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line(".") - 1, { "" }) end end)
vim.keymap.set("", "<M-F>", function() vim.lsp.buf.format({ async = true }) end)

vim.keymap.set("i", "<CR>",
  function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>" end,
  { expr = true, noremap = true }
)
vim.keymap.set("i", "<Tab>",
  function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>" end,
  { expr = true, noremap = true }
)

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
vim.keymap.set("n", "gy", function() vim.lsp.buf.type_definition() end)
vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end)
vim.keymap.set("n", "gI", function() vim.lsp.buf.implementation() end)
vim.keymap.set("n", "gA", function() vim.lsp.buf.references() end)

vim.keymap.set("n", "cd", function() vim.lsp.buf.rename() end)
vim.keymap.set("n", "g.", function() vim.lsp.buf.code_action() end)
