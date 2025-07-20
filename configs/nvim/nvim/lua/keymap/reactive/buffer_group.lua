local Signal = require("keymap.reactive.signal").Signal

---@class keymap.BufferGroup
---@field type "BufferGroup"
---@field private _signal keymap.Signal
---@field private _buffers table<keymap.Buffer, true>
local BufferGroup = {
    type = "BufferGroup",
}
BufferGroup.__index = BufferGroup

---@return keymap.BufferGroup
function BufferGroup.new()
    local self = {
        _signal = Signal.new(),
        _buffers = {},
    }
    return setmetatable(self, BufferGroup)
end

---@return keymap.Signal
function BufferGroup:signal()
    return self._signal
end

---@return keymap.BufferGroup
function BufferGroup.global()
    return BufferGroup._GLOBAL
end

---@param buffer keymap.Buffer
function BufferGroup:add(buffer)
    if not self._buffers[buffer] then
        self._buffers[buffer] = true
        self:signal():emit()
    end
end

---@param buffer keymap.Buffer
function BufferGroup:remove(buffer)
    if self._buffers[buffer] then
        self._buffers[buffer] = nil
        self:signal():emit()
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
