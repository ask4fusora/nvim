local M = {
  platform = {},
  array = {},
  debug = {},
  condition = {}
}

local print_debug_flat

---@param object any
---@param parent_prefix string?
print_debug_flat = function(object, parent_prefix)
  parent_prefix = parent_prefix or ""

  if type(object) == "table" then
    for key, value in pairs(object) do
      local current_key ---@type string

      if type(key) ~= "string" then
        current_key = tostring(key)
      end

      if parent_prefix == "" then
        current_key = key
      else
        current_key = "." .. key
      end

      local full_key = parent_prefix .. current_key

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
  find_pos = find_pos_array
}

return M
