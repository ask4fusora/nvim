local M = {}

---@param direction "next" | "prev"
local go_to_reference = function(direction)
  local array = require("util").array
  local filename = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local cursor_position = vim.api.nvim_win_get_cursor(0) -- { line, character }
  cursor_position[2] = cursor_position[2] + 1            -- I don't know why neovim does this.

  ---@param t vim.lsp.LocationOpts.OnList
  local on_list = function(t)
    local filtered_items = array.filter(t.items, function(item)
      local item_filename = vim.fs.normalize(item.filename)
      return item_filename == filename
    end)

    if #filtered_items <= 1 then return vim.notify("No references found") end

    local current_index = array.find_pos(filtered_items, function(item)
      return
          item.lnum == cursor_position[1]
          and item.col <= cursor_position[2]
          and cursor_position[2] <= item.end_col
    end)

    local target_index = direction == "next"
        and current_index % #filtered_items + 1
        or (current_index - 2) % #filtered_items + 1

    vim.lsp.util.show_document(
      filtered_items[target_index].user_data,
      vim.bo.fileencoding,
      { reuse_win = true, focus = true }
    )
  end

  vim.lsp.buf.references(nil, { on_list = on_list })
end

M.go_to_next_reference = function() go_to_reference('next') end
M.go_to_previous_reference = function() go_to_reference('prev') end

return M
