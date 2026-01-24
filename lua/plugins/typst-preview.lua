---@type VimPack.Config
return {
    specs = {
        {
            src = "https://github.com/chomosuke/typst-preview.nvim",
            version = vim.version.range("1"),
        },
    },
    trigger = {
        file_types = { "typst" },
    },
    config = function()
        require("typst-preview").setup({})
    end,
}
