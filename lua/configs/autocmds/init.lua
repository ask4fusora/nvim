local conditions = require("libs.conditions")

-- dispatchers

require('libs.autocmds.dispatchers.normal-leave').setup()

-- nohlsearch

vim.api.nvim_create_autocmd('CmdlineEnter', {
    callback = function() vim.o.hlsearch = true end
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
    callback = function() vim.o.hlsearch = false end
})

-- yank utils

vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
    callback = function() vim.g.cursor_position = vim.fn.getpos(".") end
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        if vim.v.event.operator == "y" then vim.fn.setpos(".", vim.g.cursor_position) end
        vim.hl.on_yank({ higroup = "Visual", timeout = 233 })
    end
})

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

-- help

vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function() vim.cmd.wincmd("L") end
})
