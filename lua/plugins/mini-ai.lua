---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/nvim-mini/mini.ai" },
    },
    defer_ms = 1,
    config = function()
        require("mini.ai").setup({})
    end,
}
