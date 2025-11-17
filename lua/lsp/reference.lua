local M = {}

local util = require('util')

---@param items vim.quickfix.entry[]
---@param direction "next" | "prev"
local get_next_index = function(items, direction)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1], cursor_pos[2]

  local current_index = util.array.find_pos(items, function(item)
    -- `character + 1` to convert 0-index col index to 1-index array index
    return item.lnum == row and util.math.is_in_range(col + 1, {
      start = item.col,
      ['end'] = item.end_col,
    })
  end)

  local next_index = direction == "next"
      and current_index % #items
      or (current_index - 2) % #items

  return 1 + next_index -- 0-index system calculation to 1-index system result
end

---@param references vim.quickfix.entry[]
---@param direction 'next' | 'prev'
local navigate_to_next_reference = function(references, direction)
  vim.lsp.util.show_document(
    references[get_next_index(references, direction)].user_data,
    vim.bo.fileencoding,
    { reuse_win = true, focus = true }
  )
end

---@param result lsp.DocumentHighlight[]
---@param context lsp.HandlerContext
---@return vim.quickfix.entry[]
local get_references_from_lsp_result = function(result, context)
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
local get_all_references = function(results)
  return util.array.reduce(results, {}, function(references, result)
    return vim.list_extend(
      references,
      get_references_from_lsp_result(result.result or {}, result.context)
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
local go_to_reference = function(direction)
  vim.lsp.buf_request_all(
    vim.api.nvim_get_current_buf(),
    "textDocument/documentHighlight",
    get_position_params,
    function(results)
      local references = get_all_references(results)

      if not next(references) then
        vim.notify('No references found')
        return
      end

      navigate_to_next_reference(references, direction)
    end
  )
end

M.go_to_reference = go_to_reference
M.go_to_next_reference = function() go_to_reference('next') end
M.go_to_previous_reference = function() go_to_reference('prev') end

return M
