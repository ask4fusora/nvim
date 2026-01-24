---@param pivot number
---@param range { start: number, end: number }
local function is_in_range(pivot, range)
    return range.start <= pivot and pivot <= range['end']
end

return {
    is_in_range = is_in_range
}
