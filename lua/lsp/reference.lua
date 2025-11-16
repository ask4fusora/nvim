local M = {}

local array = require("util").array

---@alias LspReferenceItem {
---  kind: number,
---  range: {
---    start: {
---      line: number,
---      character: number,
---    },
---    end: {
---      line: number,
---      character: number,
---    },
---  },
---}

---@param cursor_position [integer, integer] { line, character }
---@param range [integer, integer] { start_column, end_column }
local is_cursor_in_column_range = function(cursor_position, range)
  return range[1] <= cursor_position[2] and cursor_position[2] <= range[2]
end

---@param items vim.quickfix.entry[]
---@param cursor_position [integer, integer] { line, character }
-- ---
-- Find the index of the symbol the cursor is on in the references list.
local find_current_reference_index = function(items, cursor_position)
  return array.find_pos(items, function(item)
    return item.lnum == cursor_position[1]
        and is_cursor_in_column_range(cursor_position, { item.col, item.end_col })
  end)
end

---@param entry vim.quickfix.entry
local jump_to = function(entry)
  return vim.lsp.util.show_document(
    entry.user_data,
    vim.bo.fileencoding,
    { reuse_win = true, focus = true }
  )
end

---@param modulo integer
---@param current_index integer
---@param direction "next" | "prev"
local get_next_index = function(modulo, current_index, direction)
  local next_index = direction == "next"
      and current_index % modulo
      or (current_index - 2) % modulo

  return 1 + next_index -- 1-indexed system
end

---@param items vim.quickfix.entry[]
---@param direction 'next' | 'prev'
local navigate = function(items, direction)
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  cursor_position[2] = cursor_position[2] + 1 -- Column's index counts differently

  local current_index = find_current_reference_index(items, cursor_position)
  local target_index = get_next_index(#items, current_index, direction)

  jump_to(items[target_index])
end

---@param direction "next" | "prev"
local go_to_reference = function(direction)
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  vim.lsp.buf_request_all(bufnr, "textDocument/documentHighlight",
    function(client)
      return vim.lsp.util.make_position_params(win, client.offset_encoding)
    end,
    function(results)
      local all_items = {} ---@type vim.quickfix.entry[]

      for client_id, result in pairs(results) do
        local client = assert(vim.lsp.get_client_by_id(client_id))
        local locations = result.result ---@type LspReferenceItem[]

        if locations then
          locations = vim.tbl_map(function(location)
            location.uri = result.context.params.textDocument.uri
            return location
          end, locations)

          local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)

          vim.list_extend(all_items, items)
        end
      end

      if not next(all_items) then
        vim.notify('No references found')
        return
      end

      navigate(all_items, direction)
    end
  )
end

M.go_to_next_reference = function() go_to_reference('next') end
M.go_to_previous_reference = function() go_to_reference('prev') end

return M
