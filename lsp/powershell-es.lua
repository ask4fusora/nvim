---@type vim.lsp.Config
return {
  cmd = function(dispatchers)
    local shell = vim.lsp.config["powershell-es"].shell or 'pwsh'

    local command_fmt = [[Start-EditorServices.ps1 -Stdio]]
    local command = command_fmt:format()
    local cmd = { shell, '-NoLogo', '-NoProfile', '-Command', command }

    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  filetypes = { 'ps1' },
  root_markers = { 'PSScriptAnalyzerSettings.psd1', '.git' },
}
