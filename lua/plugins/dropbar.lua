---@type VimPack.Config
return {
    specs = { { src = "https://github.com/Bekaboo/dropbar.nvim" } },
    dependencies = { 'plugins.nvim-treesitter', 'plugins.nvim-web-devicons' },
    trigger = {
        events = { "BufRead", "BufNewFile" }
    }
}
