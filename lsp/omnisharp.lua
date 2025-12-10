---@brief
---
--- https://github.com/omnisharp/omnisharp-roslyn
--- OmniSharp server based on Roslyn workspaces
---
--- `omnisharp-roslyn` can be installed by downloading and extracting a release from [here](https://github.com/OmniSharp/omnisharp-roslyn/releases).
--- OmniSharp can also be built from source by following the instructions [here](https://github.com/omnisharp/omnisharp-roslyn#downloading-omnisharp).
---
--- OmniSharp requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.
---
--- **By default, omnisharp-roslyn doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of the unzipped run script or binary.
---
--- For `go_to_definition` to work fully, extended `textDocument/definition` handler is needed, for example see [omnisharp-extended-lsp.nvim](https://github.com/Hoffs/omnisharp-extended-lsp.nvim)
---
---

-- Standalone root_pattern for Neovim 0.12
-- Returns a function which matches a filepath against the given glob/wildcard patterns.
-- Usage:
--   local rp = require('root_pattern').root_pattern('package.json', '.git')
--   local root = rp(vim.fn.getcwd())

local uv = vim.loop
local fn = vim.fn
local fs_parents = vim.fs.parents
local fs_realpath = uv.fs_realpath -- may be nil on some environments

local function escape_wildcards(s)
  return s:gsub('([%[%]%?%*])', '\\%1')
end

local function tbl_flatten(t)
  local out = {}
  local function flat(v)
    if type(v) ~= 'table' then
      table.insert(out, v)
    else
      for _, e in ipairs(v) do flat(e) end
    end
  end
  flat(t)
  return out
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
local function strip_archive_subpath(path)
  if not path then return path end
  -- Matches regex from zip.vim / tar.vim
  path = fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

-- Walk ancestors beginning with startpath; call `func` on each directory.
-- If func returns truthy for a directory, return that directory.
local function search_ancestors(startpath, func)
  if not startpath then return end
  if func(startpath) then
    return startpath
  end
  for dir in fs_parents(startpath) do
    if func(dir) then
      return dir
    end
  end
end

local function root_pattern(...)
  local patterns = tbl_flatten { ... }
  return function(startpath)
    startpath = strip_archive_subpath(startpath or fn.getcwd())
    for _, pattern in ipairs(patterns) do
      local match = search_ancestors(startpath, function(path)
        -- Build a glob like "<escaped-dir>/<pattern>"
        local glob_path = table.concat({ escape_wildcards(path), pattern }, '/')
        for _, p in ipairs(fn.glob(glob_path, true, true)) do
          if uv.fs_stat(p) then
            return true
          end
        end
      end)

      if match ~= nil then
        local real = (fs_realpath and fs_realpath(match)) or nil
        return real or match
      end
    end
  end
end

---@type vim.lsp.Config
return {
  cmd = {
    vim.fn.executable('OmniSharp') == 1 and 'OmniSharp' or 'omnisharp',
    '-z', -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
    '--hostPID',
    tostring(vim.fn.getpid()),
    'DotNet:enablePackageRestore=false',
    '--encoding',
    'utf-8',
    '--languageserver',
  },
  filetypes = { 'cs', 'vb' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
      root_pattern '*.sln' (fname)
      or root_pattern '*.csproj' (fname)
      or root_pattern 'omnisharp.json' (fname)
      or root_pattern 'function.json' (fname)
    )
  end,
  init_options = {},
  capabilities = {
    workspace = {
      workspaceFolders = false, -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
    },
  },
  settings = {
    FormattingOptions = {
      -- Enables support for reading code style, naming convention and analyzer
      -- settings from .editorconfig.
      EnableEditorConfigSupport = true,
      -- Specifies whether 'using' directives should be grouped and sorted during
      -- document formatting.
      OrganizeImports = nil,
    },
    MsBuild = {
      -- If true, MSBuild project system will only load projects for files that
      -- were opened in the editor. This setting is useful for big C# codebases
      -- and allows for faster initialization of code navigation features only
      -- for projects that are relevant to code that is being edited. With this
      -- setting enabled OmniSharp may load fewer projects and may thus display
      -- incomplete reference lists for symbols.
      LoadProjectsOnDemand = nil,
    },
    RoslynExtensionsOptions = {
      -- Enables support for roslyn analyzers, code fixes and rulesets.
      EnableAnalyzersSupport = nil,
      -- Enables support for showing unimported types and unimported extension
      -- methods in completion lists. When committed, the appropriate using
      -- directive will be added at the top of the current file. This option can
      -- have a negative impact on initial completion responsiveness,
      -- particularly for the first few completion sessions after opening a
      -- solution.
      EnableImportCompletion = nil,
      -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
      -- true
      AnalyzeOpenDocumentsOnly = nil,
      -- Enables the possibility to see the code in external nuget dependencies
      EnableDecompilationSupport = nil,
    },
    RenameOptions = {
      RenameInComments = nil,
      RenameOverloads = nil,
      RenameInStrings = nil,
    },
    Sdk = {
      -- Specifies whether to include preview versions of the .NET SDK when
      -- determining which version to use for project loading.
      IncludePrereleases = true,
    },
  },
}
