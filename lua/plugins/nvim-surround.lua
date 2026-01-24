---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/kylechui/nvim-surround" },
    },
    trigger = {
        keymaps = {
            { mode = "n", lhs = "ys" },
            { mode = "n", lhs = "ds" },
            { mode = "n", lhs = "cs" },
            { mode = "x", lhs = "S" },
        },
    },
    config = function()
        require("nvim-surround").setup({})
    end,
}
