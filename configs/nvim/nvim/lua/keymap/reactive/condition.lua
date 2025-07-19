local Signal = require("keymap.reactive.signal").Signal

---@class keymap.Condition
---@field private _signal keymap.Signal
local Condition = {}
Condition.__index = Condition

---@return keymap.Condition
function Condition.new()
    local self = {
        _signal = Signal.new()
    }
    return setmetatable(self, Condition)
end

---@return keymap.SignalId
function Condition:signal_id()
    return self._signal:id()
end

---@return boolean
function Condition:enabled()
    error("Condition:enabled() must be implemented by subclasses")
end

---@param listener fun()
function Condition:on_change(listener)
    self._signal:listen(listener)
end

function Condition:notify_changed()
    self._signal:emit()
end

---@class keymap.CallbackCondition: keymap.Condition
---@field private _predicate fun(): boolean
local CallbackCondition = {}
setmetatable(CallbackCondition, Condition)
CallbackCondition.__index = CallbackCondition

---@param predicate fun(): boolean
---@return keymap.CallbackCondition
function CallbackCondition.new(predicate)
    local self = Condition.new() --[[@as keymap.CallbackCondition]]
    self._predicate = predicate
    return setmetatable(self, CallbackCondition)
end

---@return boolean
function CallbackCondition:enabled()
    return self._predicate()
end

---@class keymap.StatefulCondition: keymap.Condition
---@field private _enabled boolean
local StatefulCondition = {}
setmetatable(StatefulCondition, Condition)
StatefulCondition.__index = StatefulCondition

---@param default boolean?
---@return keymap.StatefulCondition
function StatefulCondition.new(default)
    local self = Condition.new() --[[@as keymap.StatefulCondition]]
    self._enabled = default or false
    return setmetatable(self, StatefulCondition)
end

---@return boolean
function StatefulCondition:enabled()
    return self._enabled
end

---@param enabled boolean
function StatefulCondition:update(enabled)
    if self._enabled ~= enabled then
        self._enabled = enabled
        self:notify_changed()
    end
end

return {
    CallbackCondition = CallbackCondition,
    StatefulCondition = StatefulCondition
}
