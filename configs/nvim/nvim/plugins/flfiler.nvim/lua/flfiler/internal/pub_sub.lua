---@alias CallbackSubscriber fun(message: unknown, unsubscribe?: fun())

---@class Broker
---@field private _subscribers { callback: CallbackSubscriber, unsubscribe: fun() }[]
local Broker = {}
Broker.__index = Broker

---@return Broker
function Broker.new()
    local self = {
        _subscribers = {}
    }
    return setmetatable(self, Broker)
end

---@param callback CallbackSubscriber
function Broker:unsubscribe(callback)
    for index, subscriber in ipairs(self._subscribers) do
        if subscriber.callback == callback then
            table.remove(self._subscribers, index)
            break
        end
    end
end

---@param callback CallbackSubscriber
---@return fun() unsubscribe
function Broker:subscribe(callback)
    local unsubscribe = function()
        self:unsubscribe(callback)
    end
    table.insert(self._subscribers, { callback = callback, unsubscribe = unsubscribe })
    return unsubscribe
end

---@param message unknown
function Broker:publish(message)
    for _, subscriber in ipairs(self._subscribers) do
        subscriber.callback(message, subscriber.unsubscribe)
    end
end

---@alias Publish<T> fun(message: T)
---@alias Subscribe<T> fun(f: fun(message: T, unsubscribe?: fun())): fun()

---@generic T
---@param _ `T`
---@return fun(message: T) publish, (fun(f: fun(message: T)): fun() ) subscribe
return function(_)
    local broker = Broker.new()
    local publisher = function(message)
        broker:publish(message)
    end
    local subscriber = function(f)
        return broker:subscribe(f)
    end
    return publisher, subscriber
end
