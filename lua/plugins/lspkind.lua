vim.pack.add({
  { src = "https://github.com/microsoft/vscode-codicons" },
  { src = "https://github.com/onsails/lspkind.nvim" }
})

require("lspkind").setup({
  mode = "symbol_text",
  preset = "codicons"
})
