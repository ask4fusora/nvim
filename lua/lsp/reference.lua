local M = {}

local array = require("util").array

---@alias LspReferenceItem.UserData {
---  uri: string,
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

---@alias LspReferenceItem {
---  filename: string,
---  text: string,
---  lnum: integer,
---  end_lnum: integer,
---  col: number,
---  end_col: number,
---  user_data: LspReferenceItem.UserData,
---}

---@param cursor_position [integer, integer] { line, character }
---@param range [integer, integer] { start_column, end_column }
local is_cursor_in_column_range = function(cursor_position, range)
  return range[1] <= cursor_position[2] and cursor_position[2] <= range[2]
end

---@param items LspReferenceItem[]
---@param filename string Full normalized path of the current file
-- ---
-- Filter reference items that is in the current filename.
local filter_lsp_reference_items = function(items, filename)
  return array.filter(items, function(item)
    return
        vim.fs.normalize(item.filename) == filename
        and item.lnum == item.end_lnum
  end)
end

---@param items LspReferenceItem[]
---@param cursor_position [integer, integer] { line, character }
-- ---
-- Find the index of the symbol the cursor is on in the references list.
local find_current_reference_index = function(items, cursor_position)
  return array.find_pos(items, function(item)
    return
        item.lnum == cursor_position[1]
        and is_cursor_in_column_range(cursor_position, { item.col, item.end_col })
  end)
end

---@param location LspReferenceItem.UserData
local jump_to = function(location)
  return vim.lsp.util.show_document(
    location,
    vim.bo.fileencoding,
    { reuse_win = true, focus = true }
  )
end

---@param current_index integer
---@param direction "next" | "prev"
---@param modulo integer
local get_next_index = function(current_index, direction, modulo)
  local next_index = direction == "next"
      and current_index % modulo
      or (current_index - 2) % modulo

  return 1 + next_index -- 1-indexed system
end

---@param t vim.lsp.LocationOpts.OnList
---@param direction 'next' | 'prev'
---@param filename string
---@param cursor_position [integer, integer] { line, character }
local navigate = function(t, direction, filename, cursor_position)
  local filtered_items = filter_lsp_reference_items(t.items, filename)

  if #filtered_items <= 1 then return vim.notify("No references found") end

  local current_index = find_current_reference_index(filtered_items, cursor_position)
  local target_index = get_next_index(current_index, direction, #filtered_items)

  jump_to(filtered_items[target_index].user_data)
end

---@param direction "next" | "prev"
local go_to_reference = function(direction)
  local filename = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local cursor_position = vim.api.nvim_win_get_cursor(0) --

  cursor_position[2] = cursor_position[2] + 1            -- Column's index counts differently

  vim.lsp.buf.references({ includeDeclaration = true }, {
    on_list = function(t) return navigate(t, direction, filename, cursor_position) end
  })
end

M.go_to_next_reference = function() go_to_reference('next') end
M.go_to_previous_reference = function() go_to_reference('prev') end

return M
