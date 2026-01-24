---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/justinmk/vim-sneak" },
    },
    trigger = {
        keymaps = {
            { mode = "n", lhs = "<leader>s" },
            { mode = "n", lhs = "<leader>S" },
            { mode = "x", lhs = "<leader>s" },
            { mode = "x", lhs = "<leader>S" },
            { mode = "o", lhs = "<leader>s" },
            { mode = "o", lhs = "<leader>S" },
        },
    },
    config = function()
        vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>Sneak_s")
        vim.keymap.set({ "n", "x", "o" }, "<leader>S", "<Plug>Sneak_S")
    end,
}
