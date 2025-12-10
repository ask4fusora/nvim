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
  -- "taplo",
  "powershell-es",
  -- "typescript-language-server",
  "vtsls",
  "rust-analyzer",
  "phptools"
})

---@param client vim.lsp.Client
---@param args vim.api.keyset.create_autocmd.callback_args
local setup_lsp_capabilities = function(client, args)
  -- Completion

  if client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
  end

  -- Inlay hint

  if client:supports_method('textDocument/inlayHint') and vim.g.is_inlay_hint_auto then
    vim.api.nvim_create_autocmd("ModeChanged", {
      buffer = args.buf,
      callback = function()
        local is_normal_mode = vim.fn.mode() == "n"
        vim.lsp.inlay_hint.enable(is_normal_mode, { bufnr = args.buf })
      end
    })
  end

  -- DocumentHighlight

  if client:supports_method('textDocument/documentHighlight') then
    -- require('lsp.document-highlight').setup_lsp_document_highlight(args, client)
  end

  -- DocumentFormatting

  if client:supports_method('textDocument/formatting') then
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
    -- The newest client that has been prepended to the array
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    setup_lsp_capabilities(client, args)
  end,
})
