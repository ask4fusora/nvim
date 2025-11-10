---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
    ".nvim" -- neovim exrc
  },
  settings = {
    Lua = {
      workspace = {
        ignoreDir = { ".nvim" } }
    }
  },
  on_init = function(client)
    local workspace_folders = client.workspace_folders

    if not workspace_folders then return end

    local workspace_folder = vim.fn.expand(workspace_folders[1].name)
    local to_be_under_dot_nvim = vim.api.nvim_buf_get_name(0):find(".nvim", 1, true) and true or false
    local to_load_vimruntime = workspace_folder == vim.fn.stdpath("config") or to_be_under_dot_nvim

    if not to_load_vimruntime then return end

    local lua_settings = client.config.settings.Lua

    if type(lua_settings) == "table" then
      client.config.settings.Lua = vim.tbl_deep_extend("force", lua_settings, {
        runtime = {
          version = 'LuaJIT',
          path = {
            "lua/?.lua",
            "lua/?/init.lua"
          }
        },
        workspace = {
          library = vim.api.nvim_list_runtime_paths()
        }
      })
    end
  end,
}
