---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/nvim-mini/mini.icons" },
        { src = "https://github.com/nvim-mini/mini.completion" },
    },
    dependencies = {
        "plugins.nvim-web-devicons",
    },
    trigger = {
        events = { "InsertEnter" },
    },
    config = function()
        local mini_completion = require("mini.completion")

        mini_completion.setup({
            lsp_completion = {
                source_func = "omnifunc",
            },
            mappings = {
                scroll_down = "<C-d>",
                scroll_up = "<C-u>",
            },
        })
    end,
}
