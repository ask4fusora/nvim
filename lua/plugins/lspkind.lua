---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/microsoft/vscode-codicons" },
        { src = "https://github.com/onsails/lspkind.nvim" },
    },
    dependencies = {
        "plugins.nvim-web-devicons",
    },
    trigger = {
        events = { "InsertEnter" },
    },
    config = function()
        require("lspkind").setup({
            mode = "symbol_text",
            preset = "codicons",
        })
    end,
}
