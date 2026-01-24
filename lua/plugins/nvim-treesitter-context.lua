---@type VimPack.Config
return {
    specs = { { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" } },
    dependencies = { 'plugins.nvim-treesitter', 'plugins.nvim-web-devicons' },
    trigger = {
        events = { "BufRead", "BufNewFile" },
        keymaps = {
            { mode = 'n', lhs = '<leader>k' }
        }
    },
    config = function()
        local treesitter_context = require('treesitter-context')

        treesitter_context.setup({
            enable = true,
        })

        vim.keymap.set('n', '<leader>k', function() treesitter_context.go_to_context(vim.v.count1) end)
    end
}
