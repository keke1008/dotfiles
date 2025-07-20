local Signal = require("keymap.reactive.signal").Signal

---@class keymap.BufferSet
---@field type "BufferSet"
---@field private _signal keymap.Signal
---@field private _buffers table<keymap.Buffer, true>
local BufferSet = {
    type = "BufferSet",
}
BufferSet.__index = BufferSet

---@return keymap.BufferSet
function BufferSet.new()
    local self = {
        _signal = Signal.new(),
        _buffers = {},
    }
    return setmetatable(self, BufferSet)
end

---@return keymap.Signal
function BufferSet:signal()
    return self._signal
end

---@return keymap.BufferSet
function BufferSet.global()
    return BufferSet._GLOBAL
end

---@param buffer keymap.Buffer
function BufferSet:add(buffer)
    if not self._buffers[buffer] then
        self._buffers[buffer] = true
        self:signal():emit()
    end
end

---@param buffer keymap.Buffer
function BufferSet:remove(buffer)
    if self._buffers[buffer] then
        self._buffers[buffer] = nil
        self:signal():emit()
    end
end

---@return keymap.Buffer[]
function BufferSet:list()
    return vim.tbl_keys(self._buffers)
end

---@private
BufferSet._GLOBAL = BufferSet.new()
BufferSet._GLOBAL:add("global")

return {
    BufferSet = BufferSet,
}
