local function setup()
    local normal_leave_augroup = vim.api.nvim_create_augroup("NormalLeave", { clear = true })

    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "n*:*",
        group = normal_leave_augroup,
        callback = function()
            ---@type { old_mode: string, new_mode: string }
            local event = vim.v.event
            local old_mode = event.old_mode
            local new_mode = event.new_mode

            if old_mode:sub(1, 1) == new_mode:sub(1, 1)
                or new_mode:sub(1, 1) == 'n' then
                return
            end

            vim.schedule(function()
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "NormalLeave",
                    data = { old_mode = old_mode, new_mode = new_mode }
                })
            end)
        end
    })
end

return {
    setup = setup
}
