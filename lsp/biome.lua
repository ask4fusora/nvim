---@type vim.lsp.Config
return {
  cmd = { "biome", "lsp-proxy" },
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
  root_markers = {
    "package-lock.json",
    "yarn.lock",
    "pnpm-lock.yaml",
    "bun.lockb",
    "bun.lock",
    "biome.json",
    "biome.jsonc"
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', { ".git" } }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local biome_config_files = { 'biome.json', 'biome.jsonc' }
    local biome_config_file_finds = vim.fs.find(biome_config_files, {
      path = vim.fs.dirname(filename),
      stop = project_root,
      type = 'file',
      limit = 1,
      upward = true,
    })

    if not #biome_config_file_finds == 0 then return end

    local biome_config_file = biome_config_file_finds[1]
    local biome_config_dirname = vim.fs.dirname(biome_config_file)

    on_dir(biome_config_dirname)
  end,
  workspace_required = true
}
