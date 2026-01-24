local conditions = require("libs.conditions")

vim.schedule(function()
    require("configs.autocmds.dispatchers")
    require("configs.autocmds.events")
end)

-- editorconfig

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("BufEnterEditorConfig", { clear = true }),
    callback = function(args)
        local bufnr = args.buf

        if not conditions.is_buffer_modifiable()
            or conditions.is_buffer_name_empty() then
            return
        end

        local editorconfig = require("editorconfig")

        editorconfig.properties.trim_trailing_whitespace(bufnr, "true")
        editorconfig.properties.insert_final_newline(bufnr, "true")
        editorconfig.properties.end_of_line(bufnr, "lf")
    end
})
