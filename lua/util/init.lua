local M = {
  platform = {},
  array = {},
  debug = {},
  condition = {},
  math = {}
}

local print_debug_flat

---@param object any
---@param parent_prefix string?
print_debug_flat = function(object, parent_prefix)
  parent_prefix = parent_prefix or ""

  if type(object) == "table" then
    for key, value in pairs(object) do
      local current_key = type(key) == "string"
          and key
          or tostring(key)

      local full_key = parent_prefix == ""
          and current_key
          or string.format('%s.%s', parent_prefix, current_key)

      if type(value) == "table" then
        print_debug_flat(value, full_key)
      else
        print(full_key .. " = " .. tostring(value))
      end
    end
  else
    print((parent_prefix == "" and "" or parent_prefix .. " = ") .. object)
  end
end

local print_debug_json

---@param object any
---@param indent_size integer?
---@param current_indent_level integer?
print_debug_json = function(object, indent_size, current_indent_level)
  indent_size = indent_size or 2
  current_indent_level = current_indent_level or 1

  local indent = string.rep(" ", indent_size * current_indent_level)

  if type(object) == "table" then
    if current_indent_level == 1 then print("{") end

    for key, value in pairs(object) do
      local current_key = type(key) == "string" and key or tostring(key)

      if type(value) == "table" then
        print(indent .. current_key .. " = {")
        print_debug_json(value, indent_size, current_indent_level + 1)
        print(indent .. "}")
      else
        print(indent .. current_key .. " = " .. tostring(value))
      end
    end

    if current_indent_level == 1 then print("}") end
  else
    print(object)
  end
end

---@generic T
---@param array T[] The list to filter.
---@param predicate fun(item: T, index: integer): boolean The test function.
---@return T[] result A new list with only the elements that passed the test.
-- ---
-- Filters a list based on a predicate function.
local filter_array = function(array, predicate)
  local result = {}

  for i, v in ipairs(array) do
    if predicate(v, i) then table.insert(result, v) end
  end

  return result
end

---@generic T
---@generic R
---@param array T[] The list to map over.
---@param transformer fun(item: T, index: integer): R The item transform function.
---@return table<integer, R> result A new list with the elements that had been transformed.
local map_array = function(array, transformer)
  local result = {}

  for i, v in ipairs(array) do
    table.insert(result, transformer(v, i))
  end

  return result
end

---@generic T
---@param array T[] The list to filter.
---@param predicate fun(item: T, index: integer): boolean The test function.
---@return integer index The position of the first item, or 0 if doesn't find any.
-- ---
-- Find the position of the first elemement in the array that passes the test.
local find_pos_array = function(array, predicate)
  for i, v in ipairs(array) do
    if predicate(v, i) then return i end
  end

  return 0
end

---@param size integer
---@param current_index integer
---@param shift integer
---@return integer
local shift_index = function(size, current_index, shift)
  return (current_index + shift - 1) % size + 1
end

---@generic T
---@generic R
---@param array T[]
---@param initial_value R
---@param reducer fun(reduced_value: R, item: T, index: integer): R
local reduce_array = function(array, initial_value, reducer)
  local reduced_value = initial_value

  for i, v in ipairs(array) do
    reduced_value = reducer(reduced_value, v, i)
  end

  return reduced_value
end

local is_git_workspace = function()
  local filepath = vim.fn.expand('%:p:h')
  local gitdir = vim.fn.finddir('.git', filepath .. ';')

  return gitdir and #gitdir > 0 and #gitdir < #filepath
end

---@param bufnr integer?
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

---@param pivot number
---@param range { start: number, end: number }
local is_in_range = function(pivot, range)
  return range.start <= pivot and pivot <= range['end']
end

M.condition = {
  is_git_workspace = is_git_workspace,
  is_buffer_name_empty = is_buffer_name_empty,
  is_buffer_modifiable = is_buffer_modifiable,
}

M.debug = {
  json = print_debug_json,
  flat = print_debug_flat
}

M.platform = {
  windows = function() return vim.fn.has("win32") == 1 end,
  macos = function() return vim.fn.has("mac") == 1 end,
  linux = function() return vim.fn.has("linux") == 1 end
}

M.array = {
  filter = filter_array,
  find_pos = find_pos_array,
  map = map_array,
  reduce = reduce_array,
  shift_index = shift_index,
}

M.math = {
  is_in_range = is_in_range,
}

return M
