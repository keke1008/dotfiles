---@class drawer.UniqueDrawerNameStack
---@field private stack drawer.DrawerName[]
local UniqueDrawerNameStack = {}
UniqueDrawerNameStack.__index = UniqueDrawerNameStack

---@return drawer.UniqueDrawerNameStack
function UniqueDrawerNameStack.new()
    return setmetatable({
        stack = {},
    }, UniqueDrawerNameStack)
end

---@param name drawer.DrawerName
function UniqueDrawerNameStack:push(name)
    for i, n in ipairs(self.stack) do
        if n == name then
            table.remove(self.stack, i)
            break
        end
    end
    table.insert(self.stack, name)
end

---@return drawer.DrawerName | nil
function UniqueDrawerNameStack:pop()
    return table.remove(self.stack)
end

---@return drawer.DrawerName | nil
function UniqueDrawerNameStack:peek()
    return self.stack[#self.stack]
end

function UniqueDrawerNameStack:clear()
    self.stack = {}
end

return {
    UniqueDrawerNameStack = UniqueDrawerNameStack,
}
