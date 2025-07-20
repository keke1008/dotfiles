local apply_keymap_update = require("keymap.applier").apply_keymap_update

---@class keymap.KeymapMediator
---@field private _resolver keymap.KeymapResolver
---@field private _state keymap.KeymapState
---@field private _enable_signal_handling boolean
local KeymapMediator = {}
KeymapMediator.__index = KeymapMediator

---@param resolver keymap.KeymapResolver
---@param state keymap.KeymapState
---@return keymap.KeymapMediator
function KeymapMediator.new(resolver, state)
    local self = {
        _resolver = resolver,
        _state = state,
        _enable_signal_handling = true,
    }
    return setmetatable(self, KeymapMediator)
end

---@param signal_id keymap.SignalId
function KeymapMediator:handle_signal(signal_id)
    if not self._enable_signal_handling then
        return
    end

    local affected_identifiers, partial_keymaps = self._resolver:resolve(signal_id)
    local update = self._state:update(affected_identifiers, partial_keymaps)
    apply_keymap_update(update)
end

---@generic T
---@param f fun(): T
---@return T
function KeymapMediator:without_signal_handling(f)
    local previous_state = self._enable_signal_handling
    self._enable_signal_handling = false

    local ok, result = pcall(f)
    self._enable_signal_handling = previous_state

    if not ok then
        error(result)
    end

    return result
end

---@param signal keymap.Condition | keymap.BufferGroup
function KeymapMediator:register_signal(signal)
    signal:on_change(function()
        self:handle_signal(signal:signal_id())
    end)
end

---@param mode keymap.Mode
---@param key keymap.Key
---@parm entries keymap.KeymapEntries
function KeymapMediator:register(mode, key, entries)
    for _, entry in ipairs(entries) do
        self._resolver:add({ mode = mode, key = key }, entry)
        entry.condition:notify_changed()
    end
end

return {
    KeymapMediator = KeymapMediator,
}
