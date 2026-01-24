---@param object any
---@param parent_prefix string?
local function flat(object, parent_prefix)
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
                flat(value, full_key)
            else
                print(full_key .. " = " .. tostring(value))
            end
        end
    else
        print((parent_prefix == "" and "" or parent_prefix .. " = ") .. object)
    end
end

---@param object any
---@param indent_size integer?
---@param current_indent_level integer?
local function json(object, indent_size, current_indent_level)
    indent_size = indent_size or 2
    current_indent_level = current_indent_level or 1

    local indent = string.rep(" ", indent_size * current_indent_level)

    if type(object) == "table" then
        if current_indent_level == 1 then print("{") end

        for key, value in pairs(object) do
            local current_key = type(key) == "string" and key or tostring(key)

            if type(value) == "table" then
                print(indent .. current_key .. " = {")
                json(value, indent_size, current_indent_level + 1)
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

return {
    json = json,
    flat = flat
}
