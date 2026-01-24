---@type VimPack.Config
return {
    specs        = {
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/nvim-telescope/telescope.nvim" },
        { src = "https://github.com/aznhe21/actions-preview.nvim" },
    },
    dependencies = { "plugins.nvim-web-devicons" },
    trigger      = {
        events = { "LspAttach", "BufEnter", "BufWinEnter", "BufReadPost", "BufNewFile" }
    },
    config       = function()
        local builtin = require('telescope.builtin')

        local help_tags = function() if vim.g.vimruntime then builtin.help_tags() else return "<leader>h" end end

        vim.keymap.set('n', '<C-P>', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<C-S-P>', builtin.git_files, { desc = 'Telescope git files' })
        vim.keymap.set('n', 'g/', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '	', builtin.buffers, { desc = 'Telescope buffers' })
        pcall(vim.keymap.del, "n", "gA")
        vim.keymap.set("n", "gA", builtin.lsp_references)
        pcall(vim.keymap.del, "n", "g.")
        vim.keymap.set("n", "g.", require("actions-preview").code_actions)
        vim.keymap.set("n", "gs", builtin.lsp_document_symbols)
        vim.keymap.set("n", "gS", builtin.lsp_dynamic_workspace_symbols)
        vim.keymap.set('n', '<leader>h', help_tags, { desc = 'Telescope help tags' })
        vim.keymap.set('n', '<F1>', builtin.commands, { desc = 'Telescope commands' })
    end
}
