local apply_keymap_update = require("keymap.applier").apply_keymap_update

---@class keymap.KeymapMediator
---@field private _resolver keymap.KeymapResolver
---@field private _state keymap.KeymapState
---@field private _listening_reactives table<keymap.SignalId, keymap.Reactive>
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
        _listening_reactives = {},
        _enable_batch_signal_handling = false,
        _pending_signals = {},
    }
    return setmetatable(self, KeymapMediator)
end

---@param signal_ids keymap.SignalId[]
function KeymapMediator:handle_signals(signal_ids)
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
        self:handle_signals(vim.tbl_keys(self._pending_signals))
        self._pending_signals = {}
    end

    if not ok then
        error(result)
    end

    return result
end

---@private
---@param reactive keymap.Reactive
function KeymapMediator:listen_signal(reactive)
    local signal_id = reactive:signal():id()
    if self._listening_reactives[signal_id] ~= nil then
        return
    end
    self._listening_reactives[signal_id] = reactive

    reactive:signal():listen(function()
        self:handle_signals({ signal_id })
    end)
end

---@class keymap.KeymapTable
---@field mode keymap.Mode
---@field key keymap.Key
---@field action keymap.Action
---@field condition keymap.Condition
---@field buffers keymap.BufferSet
---@field options keymap.KeymapOptions

---@param keymap keymap.KeymapTable
function KeymapMediator:add_keymap(keymap)
    ---@type keymap.KeymapEntry
    local entry = {
        action = keymap.action,
        condition = keymap.condition,
        buffers = keymap.buffers,
        options = keymap.options,
    }

    self._resolver:add({ mode = keymap.mode, key = keymap.key }, entry)

    ---@type keymap.Reactive[]
    local reactives = { keymap.condition, keymap.buffers }
    for _, reactive in ipairs(reactives) do
        self:listen_signal(reactive)
        reactive:signal():emit()
    end
end

---@param buffer keymap.Buffer
function KeymapMediator:handle_buffer_deletion(buffer)
    self:with_batch_signal_handling(function()
        for _, reactive in pairs(self._listening_reactives) do
            if reactive.type == "BufferSet" then
                reactive:remove(buffer)
            end
        end
    end)
end

return {
    KeymapMediator = KeymapMediator,
}
