local util = require("util")

local auto_newline_in_bracket_pair = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  local char_before = line:sub(col, col)
  local char_after = line:sub(col + 1, col + 1)

  if (char_before == '{' and char_after == '}')
      or (char_before == '(' and char_after == ')')
      or (char_before == '[' and char_after == ']') then
    return "<CR><Esc>O"
  end

  return "<CR>"
end

local buffer_close = function(to_save)
  if not util.condition.is_buffer_modifiable()
      or util.condition.is_buffer_name_empty() then
    vim.cmd.bd({ bang = true })
    return
  end

  if to_save then vim.cmd.update() end
  vim.cmd.bd({ bang = not to_save })
end

local toggle_inlay_hint = function()
  local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  return vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = 0 })
end

vim.keymap.set('n', '<C-i>', '<C-i>', { noremap = true })

vim.keymap.set('i', '<CR>', auto_newline_in_bracket_pair, { expr = true, noremap = true })

vim.keymap.set("", "<C-s>", function() vim.cmd.update() end, { silent = true })
vim.keymap.set("n", "ZQ", function() buffer_close() end)
vim.keymap.set("n", "ZZ", function() buffer_close(true) end)
vim.keymap.set("", "<C-S-W>", function() vim.cmd.qa({ bang = true }) end, { silent = true })

vim.keymap.set("n", "] ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line("."), { "" }) end end)
vim.keymap.set("n", "[ ", function() for _ = 1, vim.v.count1 do vim.fn.append(vim.fn.line(".") - 1, { "" }) end end)
vim.keymap.set("", "<M-F>", function() vim.lsp.buf.format({ async = true }) end)

if require("util").platform.windows() then vim.keymap.set("i", "<F13>", "<C-x><C-o>", { noremap = true, silent = true }) end
local tab_accept = function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>" end
vim.keymap.set("i", "<Tab>", tab_accept, { expr = true, noremap = true })

vim.keymap.set("n", "[r", require("lsp.reference").go_to_previous_reference)
vim.keymap.set("n", "]r", require("lsp.reference").go_to_next_reference)
vim.keymap.set("n", "gd", require("lsp.definition").go_to_definition)
vim.keymap.set("n", "gy", function() vim.lsp.buf.type_definition() end)
vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end)
vim.keymap.set("n", "gI", function() vim.lsp.buf.implementation() end)
vim.keymap.set("n", "gA", function() vim.lsp.buf.references() end)

vim.keymap.set('n', '<C-S-;>', toggle_inlay_hint)

vim.keymap.set("n", "cd", function() vim.lsp.buf.rename() end)
vim.keymap.set("n", "g.", function() vim.lsp.buf.code_action() end)

vim.keymap.set('n', '<C-k>z', function() vim.o.wrap = not vim.o.wrap end)
