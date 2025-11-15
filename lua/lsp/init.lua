vim.diagnostic.config({
  signs = function()
    return {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = ''
      }
    }
  end,
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
  -- "typescript-language-server",
  "vtsls",
  "rust-analyzer"
})

---@param client vim.lsp.Client
---@param args vim.api.keyset.create_autocmd.callback_args
local setup_lsp_capabilities = function(client, args)
  -- Completion

  if client.server_capabilities.completionProvider then
    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
  end

  -- Inlay hint

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(vim.fn.mode() == "n")

    vim.api.nvim_create_autocmd("ModeChanged", {
      buffer = args.buf,
      callback = function()
        local is_normal_mode = vim.fn.mode() == "n"
        vim.lsp.inlay_hint.enable(is_normal_mode, { bufnr = args.buf })
      end
    })
  end

  -- DocumentHighlight

  if client.server_capabilities.documentHighlightProvider then
    vim.o.updatetime = 89

    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      buffer = args.buf,
      callback = function() vim.lsp.buf.document_highlight() end
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = args.buf,
      callback = function() vim.lsp.buf.clear_references() end
    })
  end

  -- DocumentFormatting

  if client.server_capabilities.documentFormattingProvider then
    local lsp_format_on_save_augroup = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_format_on_save_augroup,
      buffer = args.buf,
      callback = function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 3000 }) end,
    })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspAttachAutocmd", { clear = true }),
  callback = function(args)
    local client_id = args.data.client_id ---@type integer?

    if not client_id then return end

    -- The newest client that has been prepended to the array
    local client = vim.lsp.get_clients({ bufnr = args.buf, id = client_id })[1]

    setup_lsp_capabilities(client, args)
  end,
})
