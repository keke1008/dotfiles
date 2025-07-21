---@class keymap.KeymapState
---@field _keymaps keymap.Keymap
local KeymapState = {}
KeymapState.__index = KeymapState

---@return keymap.KeymapState
function KeymapState.new()
    local self = {
        _keymaps = vim.defaulttable(),
    }
    return setmetatable(self, KeymapState)
end

---@param affected_identifiers keymap.KeymapIdentifierSet
---@param partial_keymaps keymap.Keymap
---@return keymap.KeymapUpdate
--- Update the keymap state with the given affected identifiers and partial keymaps.
--- This function will update the internal keymaps based on the provided identifiers and keymaps.
--- It will return a table containing the removed and updated keymaps.
function KeymapState:update(affected_identifiers, partial_keymaps)
    ---@type keymap.KeymapUpdate
    local update = {
        removed = vim.defaulttable(),
        updated = vim.defaulttable(),
    }

    for mode, keys in pairs(affected_identifiers) do
        for key, _ in pairs(keys) do
            local current_keymap = self._keymaps[mode][key]
            local new_keymap = vim.tbl_get(partial_keymaps, mode, key) or {}

            for current_buffer, current_entry in pairs(current_keymap) do
                if new_keymap[current_buffer] == nil then
                    -- The keymap entry is removed
                    update.removed[mode][key][current_buffer] = current_entry
                elseif
                    current_entry.action ~= new_keymap[current_buffer].action
                    or not vim.deep_equal(current_entry.options, new_keymap[current_buffer].options)
                then
                    -- The keymap entry is updated
                    update.updated[mode][key][current_buffer] = new_keymap[current_buffer]
                end

                -- Update the current keymap with the new entry
                self._keymaps[mode][key][current_buffer] = new_keymap[current_buffer]
            end

            for new_buffer, new_entry in pairs(new_keymap) do
                --- Use `rawget` because `current_keymap` created by `vim.defaulttable()`
                if rawget(current_keymap, new_buffer) == nil then
                    -- The keymap entry is new
                    update.updated[mode][key][new_buffer] = new_entry
                end

                -- Update the current keymap with the new entry
                self._keymaps[mode][key][new_buffer] = new_entry
            end
        end
    end

    return update
end

return {
    KeymapState = KeymapState,
}
