---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/biome'

    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end

    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    "astro",
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "vue",
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', ".git" }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    local biome_config_files = { 'biome.json', 'biome.jsonc' }
    local biome_config_file_finds = vim.fs.find(biome_config_files, {
      path = filename,
      stop = vim.fs.dirname(project_root),
      type = 'file',
      limit = 1,
      upward = true,
    })

    if #biome_config_file_finds == 0 then return end

    local biome_config_file = biome_config_file_finds[1]
    local biome_config_dirname = vim.fs.dirname(biome_config_file)

    on_dir(biome_config_dirname)
  end,
}
