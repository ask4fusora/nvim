---@param timeout_ms? integer
local function setup(timeout_ms)
    timeout_ms = timeout_ms or 233

    local group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true })

    vim.api.nvim_create_autocmd("TextYankPost", {
        group = group,
        callback = function()
            vim.hl.on_yank({ higroup = "Visual", timeout = timeout_ms })
        end
    })
end

return {
    setup = setup
}
