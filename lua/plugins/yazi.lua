vim.g.loaded_netrwPlugin = 1

---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/mikavilpas/yazi.nvim" },
    },
    trigger = {
        keymaps = {
            { mode = 'n', lhs = "<C-S-E>" }
        },
        user_commands = { "Yazi" }
    },
    config = function()
        local yazi = require("yazi")

        yazi.setup({
            open_for_directories = true,
        })

        vim.keymap.set("n", "<C-S-E>", function() yazi.yazi() end)
    end
}
