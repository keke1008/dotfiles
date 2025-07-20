---@alias keymap.Mode "n" | "i" | "v" | "x" | "s" | "c" | "t" | "o" | "l" | "r"
---@alias keymap.Key string
---@alias keymap.Buffer integer | "global"
---@alias keymap.Action string | fun()
---@alias keymap.KeymapOptions {
---     remap?: boolean,
---     nowait?: boolean,
---     silent?: boolean,
---     desc?: string,
---     expr?: boolean,
---     unique?: boolean,
---}
---@alias keymap.Keymap table<keymap.Mode, table<keymap.Key, table<keymap.Buffer, { action: keymap.Action, options: keymap.KeymapOptions }>>>
---@alias keymap.KeymapIdentifier { mode: keymap.Mode, key: keymap.Key }
---@alias keymap.KeymapIdentifierSet table<keymap.Mode, table<keymap.Key, true>>
---@alias keymap.KeymapUpdate { removed: keymap.Keymap, updated: keymap.Keymap }

---@param dst keymap.KeymapIdentifierSet This value will be modified in place.
---@param extend keymap.KeymapIdentifierSet
local function merge_keymap_identifier_sets(dst, extend)
    for mode, keys in pairs(extend) do
        dst[mode] = dst[mode] or {}
        for key in pairs(keys) do
            dst[mode][key] = true
        end
    end
end

return {
    merge_keymap_identifier_sets = merge_keymap_identifier_sets,
}
