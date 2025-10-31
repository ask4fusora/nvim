---@type vim.lsp.Config
return {
  cmd = {
    "clangd",
    "-j=4",
    "--pch-storage=memory",
    "--all-scopes-completion",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--rename-file-limit=0"
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac", -- AutoTools
    ".git",
  },
}
