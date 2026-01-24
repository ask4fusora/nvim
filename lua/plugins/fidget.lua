---@type VimPack.Config
return {
    specs = { { src = "https://github.com/j-hui/fidget.nvim" } },
    dependencies = { 'plugins.catppuccin', 'plugins.nvim-web-devicons' },
    defer_ms = 1,
    config = function()
        local fidget = require("fidget")

        fidget.setup({
            notification = {
                window = {
                    winblend = 0,
                    align = "top"
                }
            }
        })

        vim.notify = fidget.notify
    end
}
