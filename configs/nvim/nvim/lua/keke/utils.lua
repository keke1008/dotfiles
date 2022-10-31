local M = {}

---@param ... unknown
_G.put = function(...)
    for _, value in ipairs({ ... }) do
        print(vim.inspect(value))
    end
end

---@param obj table
---@param target_key unknown
---@param visited table<table, boolean>
---@param stack unknown[]
---@return boolean found
local function find_inner(obj, target_key, visited, stack)
    for key, value in pairs(obj) do
        if key == target_key then
            table.insert(stack, key)
            return true
        end

        if type(value) ~= "table" then
            goto continue
        end

        if visited[obj] then
            goto continue
        end
        visited[obj] = true

        table.insert(stack, key)
        if find_inner(value, target_key, visited, stack) then return true end
        table.remove(stack)

        ::continue::
    end

    return false
end

---@param obj table
---@param target_key unknown
---@return unknown?, unknown[]?
function _G.find(obj, target_key)
    local stack = {}
    local result = find_inner(obj, target_key, { obj = true }, stack)
    if not result then return end

    local value = obj
    for _, key in ipairs(stack) do
        value = value[key]
    end

    return value, stack
end

---@param obj table
---@param target_key unknown
function _G.findp(obj, target_key) _G.put(_G.find(obj, target_key)) end

return M
