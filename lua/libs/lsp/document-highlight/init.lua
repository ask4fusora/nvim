local M = {}

local state_store = {
    ---@type integer?
    under_cursor_request_id = nil,
}

---@param unique_id string
local create_document_highlight_augroup = function(unique_id)
    return vim.api.nvim_create_augroup(
        "DocumentHighlight" .. unique_id,
        { clear = true }
    )
end

---@param unique_id string
local create_detach_document_highlight_augroup = function(unique_id)
    return vim.api.nvim_create_augroup(
        "DetachDocumentHighlight" .. unique_id,
        { clear = true }
    )
end

---@param bufnr integer
---@param client vim.lsp.Client
local document_highlight = function(bufnr, client)
    local current_request_id = nil ---@type integer?

    local status, request_id = client:request(
        'textDocument/documentHighlight',
        vim.lsp.util.make_position_params(nil, client.offset_encoding),
        function(err, result, context, config)
            if state_store.under_cursor_request_id ~= current_request_id then return end

            if result then
                vim.lsp.handlers['textDocument/documentHighlight'](err, result, context, config)
            end
        end,
        bufnr
    )

    if status then
        current_request_id = request_id
        state_store.under_cursor_request_id = request_id
    end
end

local clear_document_highlight = function()
    vim.lsp.buf.clear_references()
    state_store.under_cursor_request_id = nil
end

---@param bufnr integer
---@param client vim.lsp.Client
---@param document_highlight_augroup integer
local create_document_highlight_autocmd = function(bufnr, client, document_highlight_augroup)
    vim.o.updatetime = 89

    vim.api.nvim_create_autocmd("CursorHold", {
        group = document_highlight_augroup,
        buffer = bufnr,
        callback = function()
            document_highlight(bufnr, client)
        end
    })
end

---@param bufnr integer
---@param document_highlight_augroup integer
local create_clear_document_highlight_autocmd = function(bufnr, document_highlight_augroup)
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = document_highlight_augroup,
        buffer = bufnr,
        callback = clear_document_highlight
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        group = document_highlight_augroup,
        buffer = bufnr,
        callback = clear_document_highlight
    })
end

local create_detach_document_highlight_autocmd = function(
    bufnr,
    client,
    detach_document_highlight_augroup,
    document_highlight_augroup
)
    vim.api.nvim_create_autocmd('LspDetach', {
        group = detach_document_highlight_augroup,
        buffer = bufnr,
        callback = function(args)
            if assert(args.data.client_id) == client.id then
                clear_document_highlight()
                state_store.under_cursor_request_id = nil
                vim.api.nvim_clear_autocmds({ group = document_highlight_augroup, buffer = bufnr })
            end
        end
    })
end

---@param args vim.api.keyset.create_autocmd.callback_args
---@param client vim.lsp.Client
M.setup = function(args, client)
    local unique_id = tostring(client.id) .. tostring(args.buf)
    local document_highlight_augroup = create_document_highlight_augroup(unique_id)
    local detach_document_highlight_augroup = create_detach_document_highlight_augroup(unique_id)

    create_document_highlight_autocmd(args.buf, client, document_highlight_augroup)
    create_clear_document_highlight_autocmd(args.buf, document_highlight_augroup)
    create_detach_document_highlight_autocmd(
        args.buf,
        client,
        detach_document_highlight_augroup,
        document_highlight_augroup
    )
end

return M
