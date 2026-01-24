---@param filepath? string
---@return boolean
local is_git_workspace = function(filepath)
    filepath = filepath or vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')

    return gitdir and #gitdir > 0 and #gitdir < #filepath
end

---@param bufnr integer?
---@return boolean
local is_buffer_name_empty = function(bufnr)
    bufnr = bufnr or 0
    return vim.fn.empty(vim.api.nvim_buf_get_name(0)) == 1
end

---@param bufnr integer?
---@return boolean
local is_buffer_modifiable = function(bufnr)
    bufnr = bufnr or 0
    return vim.api.nvim_get_option_value("modifiable", { buf = bufnr })
end

return {
    is_git_workspace = is_git_workspace,
    is_buffer_name_empty = is_buffer_name_empty,
    is_buffer_modifiable = is_buffer_modifiable,
    is_windows = function() return vim.fn.has("win32") == 1 end,
    is_macos = function() return vim.fn.has("mac") == 1 end,
    is_linux = function() return vim.fn.has("linux") == 1 end
}
