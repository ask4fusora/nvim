---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/folke/twilight.nvim" },
        { src = "https://github.com/folke/zen-mode.nvim" }
    },
    trigger = {
        keymaps = { { mode = 'n', lhs = '<C-w>f' } },
        user_commands = { "ZenMode" }
    },
    config = function()
        local zen_mode_toggle = require("zen-mode").toggle
        vim.keymap.set("n", "<C-w>f", function() zen_mode_toggle({ window = { width = 0.618 } }) end)
    end
}
