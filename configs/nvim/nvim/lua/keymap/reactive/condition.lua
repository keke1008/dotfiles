local Signal = require("keymap.reactive.signal").Signal

---@class keymap.Condition
---@field type "Condition"
---@field private _signal keymap.Signal
local Condition = {
    type = "Condition",
}
Condition.__index = Condition

---@return keymap.Condition
function Condition.new()
    local self = {
        _signal = Signal.new(),
    }
    return setmetatable(self, Condition)
end

---@return keymap.Signal
function Condition:signal()
    return self._signal
end

---@return boolean
function Condition:is_enabled()
    error("Condition:is_enabled() must be implemented by subclasses")
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
function CallbackCondition:is_enabled()
    return self._predicate()
end

---@class keymap.StatefulCondition: keymap.Condition
---@field private _enabled boolean
local StatefulCondition = {}
setmetatable(StatefulCondition, Condition)
StatefulCondition.__index = StatefulCondition

---@param initial boolean?
---@return keymap.StatefulCondition
function StatefulCondition.new(initial)
    local self = Condition.new() --[[@as keymap.StatefulCondition]]
    self._enabled = initial or false
    return setmetatable(self, StatefulCondition)
end

---@return boolean
function StatefulCondition:is_enabled()
    return self._enabled
end

---@param enabled boolean
function StatefulCondition:update(enabled)
    if self._enabled ~= enabled then
        self._enabled = enabled
        self:signal():emit()
    end
end

---@class keymap.FixedCondition: keymap.Condition
---@field private _enabled boolean
local FixedCondition = {}
setmetatable(FixedCondition, Condition)
FixedCondition.__index = FixedCondition

---@private
---@param enabled boolean
---@return keymap.FixedCondition
function FixedCondition._new(enabled)
    local self = Condition.new() --[[@as keymap.FixedCondition]]
    self._enabled = enabled
    return setmetatable(self, FixedCondition)
end

---@return boolean
function FixedCondition:is_enabled()
    return self._enabled
end

---@private
FixedCondition._TRUE = FixedCondition._new(true)
---@private
FixedCondition._FALSE = FixedCondition._new(false)

---@param enabled boolean
---@return keymap.FixedCondition
function FixedCondition.new(enabled)
    if enabled then
        return FixedCondition._TRUE
    else
        return FixedCondition._FALSE
    end
end

return {
    CallbackCondition = CallbackCondition,
    StatefulCondition = StatefulCondition,
    FixedCondition = FixedCondition,
}
