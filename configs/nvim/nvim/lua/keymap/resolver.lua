local types = require("keymap.types")

---@alias keymap.KeymapEntry {
---    condition: keymap.Condition,
---    buffers: keymap.BufferSet,
---    action: keymap.Action,
---    options: keymap.KeymapOptions,
---}

---@class keymap.SingleKeyResolver
---@field private _entries keymap.KeymapEntry[]
local SingleKeyResolver = {}
SingleKeyResolver.__index = SingleKeyResolver

---@return keymap.SingleKeyResolver
function SingleKeyResolver.new()
    local self = {
        _entries = {},
    }
    return setmetatable(self, SingleKeyResolver)
end

---@param entry keymap.KeymapEntry
function SingleKeyResolver:add(entry)
    table.insert(self._entries, entry)
end

---@return table<keymap.Buffer, { action: keymap.Action, options: keymap.KeymapOptions }>
function SingleKeyResolver:resolve()
    local resolved = {}

    for _, entry in ipairs(self._entries) do
        if not entry.condition:is_enabled() then
            goto continue
        end

        for _, buffer in ipairs(entry.buffers:list()) do
            if resolved[buffer] == nil then
                resolved[buffer] = {
                    action = entry.action,
                    options = entry.options,
                }
            end
        end

        ::continue::
    end

    return resolved
end

---@class keymap.KeymapResolver
---@field private _resolvers table<keymap.Mode, table<keymap.Key, keymap.SingleKeyResolver>>
---@field private _signal_relations table<keymap.SignalId, keymap.KeymapIdentifierSet>
local KeymapResolver = {}
KeymapResolver.__index = KeymapResolver

---@return keymap.KeymapResolver
function KeymapResolver.new()
    local self = {
        _resolvers = vim.defaulttable(function()
            -- Default value of `_resolvers[mode]`
            return vim.defaulttable(function()
                -- Default value of `_resolvers[mode][key]`
                return SingleKeyResolver.new()
            end)
        end),
        _signal_relations = vim.defaulttable(),
    }
    return setmetatable(self, KeymapResolver)
end

---@param identifier keymap.KeymapIdentifier
---@param entry keymap.KeymapEntry
function KeymapResolver:add(identifier, entry)
    local mode = identifier.mode
    local key = identifier.key

    -- Update resolvers
    self._resolvers[mode][key]:add(entry)

    -- Update relations
    self._signal_relations[entry.condition:signal():id()][mode][key] = true
    self._signal_relations[entry.buffers:signal():id()][mode][key] = true
end

---@private
---@param signal_ids keymap.SignalId[]
---@return keymap.KeymapIdentifierSet
function KeymapResolver:_affected_identifiers(signal_ids)
    ---@type table<keymap.SignalId, boolean>
    local unique_signal_ids = {}
    for _, signal_id in ipairs(signal_ids) do
        unique_signal_ids[signal_id] = true
    end

    ---@type keymap.KeymapIdentifierSet
    local affected_identifiers = {}
    for signal_id in pairs(unique_signal_ids) do
        local identifiers = self._signal_relations[signal_id]
        types.merge_keymap_identifier_sets(affected_identifiers, identifiers or {})
    end

    return affected_identifiers
end

---@private
---@param affected_identifiers keymap.KeymapIdentifierSet
---@return keymap.Keymap
function KeymapResolver:_resolve_by_affected_identifiers(affected_identifiers)
    ---@type keymap.Keymap
    local resolved_keymaps = {}

    for mode, keys in pairs(affected_identifiers) do
        if self._resolvers[mode] == nil then
            goto continue
        end

        resolved_keymaps[mode] = {}
        for key, _ in pairs(keys) do
            local resolver = self._resolvers[mode][key]
            if resolver ~= nil then
                resolved_keymaps[mode][key] = resolver:resolve()
            end
        end

        ::continue::
    end

    return resolved_keymaps
end

---@param signal_ids keymap.SignalId[]
---@return keymap.KeymapIdentifierSet, keymap.Keymap
function KeymapResolver:resolve(signal_ids)
    local affected_identifiers = self:_affected_identifiers(signal_ids)
    local resolved_keymaps = self:_resolve_by_affected_identifiers(affected_identifiers)
    return affected_identifiers, resolved_keymaps
end

---@return keymap.KeymapIdentifierSet, keymap.Keymap
function KeymapResolver:resolve_all()
    return self:resolve(vim.tbl_keys(self._signal_relations))
end

return {
    KeymapResolver = KeymapResolver,
}
