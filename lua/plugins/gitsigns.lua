---@type VimPack.Config
return {
    specs = { { src = "https://github.com/lewis6991/gitsigns.nvim" } },
    defer_ms = 1000,
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup()

        ---@param direction 'next' | 'prev'
        local go_to_hunk = function(direction)
            if vim.wo.diff then return direction and ']c' or '[c' end
            return gitsigns.nav_hunk(direction)
        end

        vim.keymap.set("n", "<leader>gs", function() gitsigns.refresh() end)
        vim.keymap.set('n', ']c', function() go_to_hunk('next') end)
        vim.keymap.set('n', '[c', function() go_to_hunk('prev') end)
    end
}
