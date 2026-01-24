local M = {}

local util = require('util')

---@param items vim.quickfix.entry[]
---@param direction "next" | "prev"
---@param count integer
local get_next_index = function(items, direction, count)
    count = direction == "next" and count or -count
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    local current_index = util.array.find_pos(items, function(item)
        -- `character + 1` to convert 0-index col index to 1-index array index
        return
            item.lnum == row
            and util.math.is_in_range(col + 1, {
                start = item.col,
                ['end'] = item.end_col,
            })
    end)

    return util.array.shift_index(#items, current_index, count)
end

---@param document_highlights vim.quickfix.entry[]
---@param direction 'next' | 'prev'
---@param count integer
local navigate_to_next_document_highlight = function(document_highlights, direction, count)
    vim.lsp.util.show_document(
        document_highlights[get_next_index(document_highlights, direction, count)].user_data,
        vim.bo.fileencoding,
        { reuse_win = true, focus = true }
    )
end

---@param result lsp.DocumentHighlight[]
---@param context lsp.HandlerContext
---@return vim.quickfix.entry[]
local get_document_highlights_from_lsp_result = function(result, context)
    local client = assert(vim.lsp.get_client_by_id(context.client_id))

    return vim.lsp.util.locations_to_items(
        util.array.map(result, function(document_highlight)
            ---@type lsp.Location
            return { uri = context.params.textDocument.uri, range = document_highlight.range }
        end),
        client.offset_encoding
    )
end

---@param results table<integer, { err: (lsp.ResponseError)?, result: any, context: lsp.HandlerContext }>
---@return vim.quickfix.entry[]
local get_all_document_highlights = function(results)
    return util.array.reduce(results, {}, function(document_highlights, result)
        return vim.list_extend(
            document_highlights,
            get_document_highlights_from_lsp_result(result.result or {}, result.context)
        )
    end)
end

---@param client vim.lsp.Client
local get_position_params = function(client)
    return vim.lsp.util.make_position_params(
        vim.api.nvim_get_current_win(),
        client.offset_encoding
    )
end

---@param direction "next" | "prev"
---@param count integer
local go_to_document_highlight = function(direction, count)
    count = count or vim.v.count1

    vim.lsp.buf_request_all(
        vim.api.nvim_get_current_buf(),
        "textDocument/documentHighlight",
        get_position_params,
        function(results)
            local document_highlights = get_all_document_highlights(results)

            if not next(document_highlights) then
                vim.notify('No document highlights found')
                return
            end

            navigate_to_next_document_highlight(document_highlights, direction, count)
        end
    )
end

M.go_to_document_highlight = go_to_document_highlight
M.go_to_next_document_highlight = function() go_to_document_highlight('next', vim.v.count1) end
M.go_to_previous_document_highlight = function() go_to_document_highlight('prev', vim.v.count1) end

return M
