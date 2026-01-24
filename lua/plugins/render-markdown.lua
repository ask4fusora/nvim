---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    },
    dependencies = {
        "plugins.nvim-treesitter",
        "plugins.nvim-web-devicons",
    },
    trigger = {
        file_types = { "markdown" },
    },
    config = function()
        require("render-markdown").setup({})
    end,
}
