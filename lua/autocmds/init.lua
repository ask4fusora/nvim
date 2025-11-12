vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
  callback = function() vim.g.cursor_position = vim.fn.getpos(".") end
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" then vim.fn.setpos(".", vim.g.cursor_position) end
    vim.hl.on_yank({ higroup = "Visual", timeout = 233 })
  end
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("BufEnterEditorConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local editorconfig = require("editorconfig")

    editorconfig.properties.trim_trailing_whitespace(bufnr, "true")
    editorconfig.properties.insert_final_newline(bufnr, "true")
    editorconfig.properties.end_of_line(bufnr, "lf")
  end
})
