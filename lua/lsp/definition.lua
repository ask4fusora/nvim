local M = {}

M.go_to_definition = function()
  vim.lsp.buf.definition({
    on_list = function(t)
      vim.lsp.util.show_document(t.items[1].user_data, vim.bo.fileencoding)
    end
  })
end

return M
