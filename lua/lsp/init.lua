vim.diagnostic.config({
  virtual_text = { spacing = 2 },
  severity_sort = true
})

vim.lsp.enable({
  "clangd",
  "lua-language-server",
  "json-language-server",
  "yaml-language-server",
  "biome",
  "tinymist",
  "basedpyright",
  "ruff",
  "tombi",
  "powershell-es",
  "typescript-language-server",
  "rust-analyzer"
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspAutocmd", { clear = false }),
  callback = function(args)
    -- The LSP client that has just been prepended to the LSP client list.
    local client = vim.lsp.get_clients({ bufnr = args.buf })[1]

    if client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(vim.api.nvim_get_mode().mode == "n")

      vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
          vim.lsp.inlay_hint.enable(vim.api.nvim_get_mode().mode == "n")
        end
      })
    end

    if client.server_capabilities.documentHighlightProvider then
      local lsp_document_highlight_augroup = vim.api.nvim_create_augroup(
        "LspDocumentHighlight" .. client.name,
        { clear = true }
      )

      vim.o.updatetime = 55

      vim.api.nvim_create_autocmd("CursorHold", {
        group = lsp_document_highlight_augroup,
        callback = function()
          vim.lsp.buf.document_highlight()
        end
      })

      vim.api.nvim_create_autocmd({ "CursorMovedI", "CursorMoved" }, {
        group = lsp_document_highlight_augroup,
        callback = function() vim.lsp.buf.clear_references() end
      })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function() vim.lsp.buf.document_highlight() end
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function() vim.lsp.buf.clear_references() end
})
