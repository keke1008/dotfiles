---@alias keymap.SignalId integer

---@type keymap.SignalId
local next_signal_id = 1

---@class keymap.Signal
---@field private _id keymap.SignalId
---@field private _listeners fun()[]
local Signal = {}
Signal.__index = Signal

---@return keymap.Signal
function Signal.new()
    local id = next_signal_id
    next_signal_id = next_signal_id + 1
    local self = {
        _id = id,
        _listeners = {},
    }
    return setmetatable(self, Signal)
end

---@return keymap.SignalId
function Signal:id()
    return self._id
end

---@param listener fun()
function Signal:listen(listener)
    table.insert(self._listeners, listener)
end

function Signal:emit()
    for _, listener in ipairs(self._listeners) do
        listener()
    end
end

return {
    Signal = Signal
}
