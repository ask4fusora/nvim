vim.o.sessionoptions = table.concat({
    "buffers",
    "help",
    "folds",
    "winsize",
    "curdir",
    "tabpages"
}, ",")

local sessions_directory = vim.fs.joinpath(vim.fn.stdpath("data"), "sessions")
vim.fn.mkdir(sessions_directory, "p")

local get_session_path = function()
    local cwd = vim.fn.getcwd()
    local session_name = vim.fn.fnamemodify(cwd, ":t")

    if session_name == "" then
        if require("libs.conditions").is_windows() then
            session_name = vim.fn.fnamemodify(cwd, ":d")
            session_name = vim.fn.substitute(session_name, ":", "", "")
        else
            session_name = "ROOT"
        end
    end

    local path_hash           = vim.fn.sha256(cwd)
    local short_hash          = vim.fn.strpart(path_hash, 0, 7)
    local unique_session_name = session_name .. short_hash

    return vim.fs.joinpath(sessions_directory, unique_session_name)
end

local save_session = function()
    local session_path = get_session_path()
    vim.cmd.mksession({ session_path, bang = true })
end

local load_session = function()
    local session_path = get_session_path()

    if vim.fn.filereadable(session_path) == 1 then
        vim.cmd.source(session_path)
    end
end

local session_group = vim.api.nvim_create_augroup("NativeSession", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
    group = session_group,
    nested = true,
    callback = function()
        if vim.fn.argc() ~= 0 then return end

        local session_path = get_session_path()

        if vim.fn.filereadable(session_path) == 1 then
            load_session()
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    group = session_group,
    callback = function()
        if vim.fn.argc() ~= 0 then return end
        save_session()
    end,
})
