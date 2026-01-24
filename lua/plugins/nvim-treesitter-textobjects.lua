---@type VimPack.Config
return {
    specs = { { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' } },
    dependencies = { "plugins.nvim-treesitter" },
    trigger = {
        events = { "BufReadPost", "BufNewFile" }
    }
}
