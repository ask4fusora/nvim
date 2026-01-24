---@generic T
---@param array T[] The list to filter.
---@param predicate fun(item: T, index: integer): boolean The test function.
---@return T[] result A new list with only the elements that passed the test.
-- ---
-- Filters a list based on a predicate function.
local function filter(array, predicate)
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
local function find_pos(array, predicate)
    for i, v in ipairs(array) do
        if predicate(v, i) then return i end
    end

    return 0
end

---@generic T
---@generic R
---@param array T[] The list to map over.
---@param transformer fun(item: T, index: integer): R The item transform function.
---@return table<integer, R> result A new list with the elements that had been transformed.
local function map(array, transformer)
    local result = {}

    for i, v in ipairs(array) do
        table.insert(result, transformer(v, i))
    end

    return result
end

---@generic T
---@generic R
---@param array T[]
---@param initial_value R
---@param reducer fun(reduced_value: R, item: T, index: integer): R
local function reduce(array, initial_value, reducer)
    local reduced_value = initial_value

    for i, v in ipairs(array) do
        reduced_value = reducer(reduced_value, v, i)
    end

    return reduced_value
end

---@param size integer
---@param current_index integer
---@param shift integer
---@return integer
local function shift_index(size, current_index, shift)
    return (current_index + shift - 1) % size + 1
end

return {
    filter = filter,
    find_pos = find_pos,
    map = map,
    reduce = reduce,
    shift_index = shift_index,
}
