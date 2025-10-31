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
  "typescript-language-server"
})

vim.keymap.set("", "<M-L>", function()
  local clients = vim.lsp.get_clients()

  vim.notify(string.format("[LSP] Restarting language servers..."), vim.log.levels.DEBUG)

  for _, client in ipairs(clients) do
    vim.lsp.enable(client.name, false)
    vim.lsp.enable(client.name, true)
  end
end)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
  callback = function(args)
    -- The LSP client that has just been prepended to the LSP client list.
    local client = vim.lsp.get_clients({ bufnr = args.buf })[1]

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true)

      vim.api.nvim_create_autocmd("InsertEnter", {
        group = vim.api.nvim_create_augroup("InlayHintEnter", { clear = true }),
        callback = function()
          vim.lsp.inlay_hint.enable(false)
        end
      })

      vim.api.nvim_create_autocmd("InsertLeave", {
        group = vim.api.nvim_create_augroup("InlayHintLeave", { clear = true }),
        callback = function()
          vim.lsp.inlay_hint.enable(true)
        end
      })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format()
  end,
})
