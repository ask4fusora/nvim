local M = {}

local platform = {
  windows = function() return vim.fn.has("win32") end,
  macos = function() return vim.fn.has("mac") end,
  linux = function() return vim.fn.has("linux") end
}

M.platform = platform

--- Filters a list based on a predicate function.
---@generic T
---@param array T[] The list to filter.
---@param predicate fun(item: T, index: integer): boolean The test function.
---@return T[] result A new list with only the elements that passed the test.
M.filter = function(array, predicate)
  local result = {}

  for i, v in ipairs(array) do
    if predicate(v, i) then table.insert(result, v) end
  end

  return result
end

return M
