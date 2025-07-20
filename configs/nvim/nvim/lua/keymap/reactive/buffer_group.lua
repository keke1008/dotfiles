local Signal = require("keymap.reactive.signal").Signal

---@class keymap.BufferGroup
---@field private _buffers table<keymap.Buffer, true>
---@field private _signal keymap.Signal
local BufferGroup = {}
BufferGroup.__index = BufferGroup

---@return keymap.BufferGroup
function BufferGroup.new()
    local self = {
        _buffers = {},
        _signal = Signal:new(),
    }
    return setmetatable(self, BufferGroup)
end

---@return keymap.BufferGroup
function BufferGroup.global()
    return BufferGroup._GLOBAL
end

---@return keymap.SignalId
function BufferGroup:signal_id()
    return self._signal:id()
end

---@param listener fun()
function BufferGroup:on_change(listener)
    self._signal:listen(listener)
end

---@param buffer keymap.Buffer
function BufferGroup:add(buffer)
    if not self._buffers[buffer] then
        self._buffers[buffer] = true
        self._signal:emit()
    end
end

---@param buffer keymap.Buffer
function BufferGroup:remove(buffer)
    if self._buffers[buffer] then
        self._buffers[buffer] = nil
        self._signal:emit()
    end
end

---@return keymap.Buffer[]
function BufferGroup:buffers()
    return vim.tbl_keys(self._buffers)
end

---@private
BufferGroup._GLOBAL = BufferGroup.new()
BufferGroup._GLOBAL:add("global")

return {
    BufferGroup = BufferGroup,
}
