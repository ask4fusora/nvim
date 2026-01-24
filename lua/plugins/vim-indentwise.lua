---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/jeetsukumaran/vim-indentwise" },
    },
    trigger = {
        keymaps = {
            { mode = "n", lhs = "[-" },
            { mode = "n", lhs = "[+" },
            { mode = "n", lhs = "[=" },
            { mode = "n", lhs = "]-" },
            { mode = "n", lhs = "]+" },
            { mode = "n", lhs = "]=" },
        },
    },
}
