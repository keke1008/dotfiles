---@param buffer keymap.Buffer
local function to_vim_buffer(buffer)
    if buffer == "global" then
        return nil
    end

    ---@cast buffer integer
    return buffer
end


---@param update keymap.KeymapUpdate
local function apply_keymap_update(update)
    for mode, keys in pairs(update.removed) do
        for key, buffers in pairs(keys) do
            for buffer, _ in pairs(buffers) do
                vim.keymap.del(mode, key, { buffer = to_vim_buffer(buffer) })
            end
        end
    end

    for mode, keys in pairs(update.updated) do
        for key, buffers in pairs(keys) do
            for buffer, entry in pairs(buffers) do
                local options = vim.tbl_extend("force", entry.options or {}, { buffer = to_vim_buffer(buffer) })
                vim.keymap.set(mode, key, entry.action, options)
            end
        end
    end
end

return {
    apply_keymap_update = apply_keymap_update,
}
