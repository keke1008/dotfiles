local KeymapResolver = require("keymap.resolver").KeymapResolver
local CallbackCondition = require("keymap.reactive.condition").CallbackCondition
local StatefulCondition = require("keymap.reactive.condition").StatefulCondition
local BufferGroup = require("keymap.reactive.buffer_group").BufferGroup
local KeymapState = require("keymap.state").KeymapState
local apply_keymap_update = require("keymap.applier").apply_keymap_update

local M = {
    _resolver = KeymapResolver.new(),
    _state = KeymapState.new(),
}

---@param signal_id keymap.SignalId
function M._on_signal_emitted(signal_id)
    local affected_identifiers, partial_keymaps = M._resolver:resolve(signal_id)
    local update = M._state:update(affected_identifiers, partial_keymaps)
    apply_keymap_update(update)
end

---@param mode keymap.Mode
---@param key keymap.Key
---@param entries keymap.KeymapEntry[]
function M.register(mode, key, entries)
    for _, entry in ipairs(entries) do
        M._resolver:add({ mode = mode, key = key }, entry)
        entry.condition:notify_changed()
    end
end

---@param predicate fun(): boolean
---@return keymap.CallbackCondition
function M.new_callback_condition(predicate)
    local condition = CallbackCondition.new(predicate)
    condition:on_change(function()
        M._on_signal_emitted(condition:signal_id())
    end)
    return condition
end

---@param initial boolean?
---@return keymap.StatefulCondition
function M.new_stateful_condition(initial)
    local condition = StatefulCondition.new(initial)
    condition:on_change(function()
        M._on_signal_emitted(condition:signal_id())
    end)
    return condition
end

---@return keymap.BufferGroup
function M.new_buffer_group()
    local buffers = BufferGroup.new()
    buffers:on_change(function()
        M._on_signal_emitted(buffers:signal_id())
    end)
    return buffers
end

---@return keymap.BufferGroup
function M.new_global_buffer_group()
    local buffers = BufferGroup.global()
    buffers:on_change(function()
        M._on_signal_emitted(buffers:signal_id())
    end)
    return buffers
end

return M
