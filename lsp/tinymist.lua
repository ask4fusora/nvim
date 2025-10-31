---@type vim.lsp.Config
return {
  cmd = { "tinymist", "lsp" },
  init_options = {
    formatterMode = "typstyle"
  },
  filetypes = { "typst" },
  root_markers = { ".git" }
}
