local function setup()
    local group = vim.api.nvim_create_augroup("RestoreCursorPositionPostYank", { clear = true })

    vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
        group = group,
        callback = function() vim.g.cursor_position = vim.fn.getpos(".") end
    })

    vim.api.nvim_create_autocmd("TextYankPost", {
        group = group,
        callback = function()
            if vim.v.event.operator == "y" then
                vim.fn.setpos(".", vim.g.cursor_position)
            end
        end
    })
end

return {
    setup = setup
}
