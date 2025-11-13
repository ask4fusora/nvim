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
  group = vim.api.nvim_create_augroup("LspAttachAutocmd", { clear = false }),
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    local client = clients[1] -- The newest client that has been prepended to the array

    vim.notify(client.name .. " attached.", vim.log.levels.INFO, { group = "LspAttach" })

    if client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(vim.api.nvim_get_mode().mode == "n")

      vim.api.nvim_create_autocmd("ModeChanged", {
        buffer = args.buf,
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

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = args.buf,
        group = lsp_document_highlight_augroup,
        callback = function() vim.lsp.buf.document_highlight() end
      })

      vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = args.buf,
        group = lsp_document_highlight_augroup,
        callback = function() vim.lsp.buf.clear_references() end
      })
    end

    if client.server_capabilities.documentFormattingProvider then
      local lsp_format_on_save_augroup = vim.api.nvim_create_augroup(
        "LspFormatOnSave" .. client.name,
        { clear = true }
      )

      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        group = lsp_format_on_save_augroup,
        callback = function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end,
      })
    end
  end,
})
