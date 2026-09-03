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
    local err = nil

    while #self.stack > 0 do
        local fn = table.remove(self.stack)
        local ok, result = pcall(fn)
        if not ok then
            err = result
        end
    end

    if err ~= nil then
        error(err)
    end
end

---@generic T, U, V
---@overload fun(self: DeferredStack, fun: fun())
---@overload fun(self: DeferredStack, fun: fun(): T): T
---@overload fun(self: DeferredStack, fun: fun(): T, U): T, U
---@overload fun(self: DeferredStack, fun: fun(): T, U, V): T, U, V
function DeferredStack:run_after(fun)
    local ok, res1, res2, res3 = pcall(fun)
    self:run()

    if ok then
        return res1, res2, res3
    else
        error(res1)
    end
end

---@generic T, U, V
---@overload fun(fun: fun(defer: fun(deferred: fun())))
---@overload fun(fun: fun(defer: fun(deferred: fun())): T): T
---@overload fun(fun: fun(defer: fun(deferred: fun())): T, U): T, U
---@overload fun(fun: fun(defer: fun(deferred: fun())): T, U, V): T, U, V
function DeferredStack.scope(fun)
    local deferred_stack = DeferredStack.new()

    return deferred_stack:run_after(function()
        ---@param deferred fun()
        local defer = function(deferred)
            deferred_stack:push(deferred)
        end

        fun(defer)
    end)
end

return DeferredStack
