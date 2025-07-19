---@alias keymap.KeymapEntry {
---    condition: keymap.Condition,
---    buffers: keymap.BufferGroup,
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
        if not entry.condition:enabled() then
            goto continue
        end

        for _, buffer in ipairs(entry.buffers:buffers()) do
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
    self._signal_relations[entry.condition:signal_id()][mode][key] = true
    self._signal_relations[entry.buffers:signal_id()][mode][key] = true
end

---@param changed_condition_id keymap.SignalId
---@return keymap.KeymapIdentifierSet, keymap.Keymap
function KeymapResolver:resolve(changed_condition_id)
    local affected_identifiers = self._signal_relations[changed_condition_id]
    if affected_identifiers == nil then
        return {}, {}
    end

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

    return affected_identifiers, resolved_keymaps
end

return {
    KeymapResolver = KeymapResolver,
}
