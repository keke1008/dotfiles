---@class DeferredStack
---@field private stack fun()[]
local DeferredStack = {}

function DeferredStack.new()
    local self = {
        stack = {},
    }
    return setmetatable(self, { __index = DeferredStack })
end

---@param self DeferredStack
---@param f fun()
function DeferredStack:push(f)
    table.insert(self.stack, f)
end

function DeferredStack:run()
    while #self.stack > 0 do
        table.remove(self.stack)()
    end
end

return DeferredStack
