local apply_keymap_update = require("keymap.applier").apply_keymap_update

---@class keymap.KeymapMediator
---@field private _resolver keymap.KeymapResolver
---@field private _state keymap.KeymapState
---@field private _listening_signals table<keymap.SignalId, true>
---@field private _enable_batch_signal_handling boolean
---@field private _pending_signals table<keymap.SignalId, true>
local KeymapMediator = {}
KeymapMediator.__index = KeymapMediator

---@param resolver keymap.KeymapResolver
---@param state keymap.KeymapState
---@return keymap.KeymapMediator
function KeymapMediator.new(resolver, state)
    local self = {
        _resolver = resolver,
        _state = state,
        _listening_signals = {},
        _enable_batch_signal_handling = false,
        _pending_signals = {},
    }
    return setmetatable(self, KeymapMediator)
end

---@param signal_ids keymap.SignalId[]
function KeymapMediator:handle_signal(signal_ids)
    if self._enable_batch_signal_handling then
        for _, signal_id in ipairs(signal_ids) do
            self._pending_signals[signal_id] = true
        end

        return
    end

    local affected_identifiers, partial_keymaps = self._resolver:resolve(signal_ids)
    local update = self._state:update(affected_identifiers, partial_keymaps)
    apply_keymap_update(update)
end

function KeymapMediator:refresh()
    local affected_identifiers, partial_keymaps = self._resolver:resolve_all()
    local update = self._state:update(affected_identifiers, partial_keymaps)
    apply_keymap_update(update)
end

---@generic T
---@param f fun(): T
---@return T
---@overload fun(self: keymap.KeymapMediator, f: fun())
function KeymapMediator:with_batch_signal_handling(f)
    local previous_state = self._enable_batch_signal_handling
    self._enable_batch_signal_handling = true

    local ok, result = pcall(f)
    self._enable_batch_signal_handling = previous_state
    if not self._enable_batch_signal_handling then
        self:handle_signal(vim.tbl_keys(self._pending_signals))
        self._pending_signals = {}
    end

    if not ok then
        error(result)
    end

    return result
end

---@private
---@param signal keymap.Condition | keymap.BufferGroup
function KeymapMediator:listen_signal(signal)
    local signal_id = signal:signal_id()
    if self._listening_signals[signal_id] then
        return
    end
    self._listening_signals[signal_id] = true

    signal:on_change(function()
        self:handle_signal({ signal_id })
    end)
end

---@param mode keymap.Mode
---@param key keymap.Key
---@param entries keymap.KeymapEntry[]
function KeymapMediator:register(mode, key, entries)
    self:with_batch_signal_handling(function()
        for _, entry in ipairs(entries) do
            self._resolver:add({ mode = mode, key = key }, entry)

            ---@type (keymap.Condition | keymap.BufferGroup)[]
            local signals = { entry.condition, entry.buffers }
            for _, signal in ipairs(signals) do
                self:listen_signal(signal)
            end
        end
    end)
end

return {
    KeymapMediator = KeymapMediator,
}
