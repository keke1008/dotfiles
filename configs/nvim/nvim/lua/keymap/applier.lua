---@param buffer keymap.Buffer
local function to_vim_buffer(buffer)
    if buffer == "global" then
        error("Cannot convert 'global' to a Vim buffer")
    end

    ---@cast buffer integer
    return buffer
end

---@return table<integer, true>
local function get_all_buffers()
    local buffers = {}
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        buffers[buffer] = true
    end
    return buffers
end


---@param update keymap.KeymapUpdate
local function apply_keymap_update(update)
    local all_buffers = get_all_buffers()

    for mode, keys in pairs(update.removed) do
        for key, buffers in pairs(keys) do
            for buffer, _ in pairs(buffers) do
                if buffer == "global" then
                    vim.keymap.del(mode, key)
                elseif all_buffers[buffer] then
                    vim.keymap.del(mode, key, { buffer = to_vim_buffer(buffer) })
                end
            end
        end
    end

    for mode, keys in pairs(update.updated) do
        for key, buffers in pairs(keys) do
            for buffer, entry in pairs(buffers) do
                if buffer == "global" then
                    vim.keymap.set(mode, key, entry.action, entry.options)
                elseif all_buffers[buffer] then
                    local options = vim.tbl_extend("force", entry.options, { buffer = to_vim_buffer(buffer) })
                    vim.keymap.set(mode, key, entry.action, options)
                end
            end
        end
    end
end

return {
    apply_keymap_update = apply_keymap_update,
}
