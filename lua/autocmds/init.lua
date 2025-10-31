vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
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
  end
})
