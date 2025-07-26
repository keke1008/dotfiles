local M = {}

---@param value any
---@return keymap.Mode
function M.mode(value)
    vim.validate("value", value, "string")
    return value
end

---@param value any
---@retury keymap.Mode[]
function M.modes(value)
    vim.validate("value", value, { "string", "table" })
    if type(value) == "string" then
        return { value }
    end
    for _, mode in ipairs(value) do
        vim.validate("mode", mode, "string")
    end
    return value
end

---@param value any
---@return keymap.Key
function M.key(value)
    vim.validate("value", value, "string")
    return value
end

---@param value any
---@return keymap.Key[]
function M.keys(value)
    vim.validate("value", value, { "string", "table" })
    if type(value) == "string" then
        return { value }
    end
    for _, key in ipairs(value) do
        vim.validate("key", key, "string")
    end
    return value
end

---@param value any
---@return keymap.Key[] | nil
function M.keys_nillable(value)
    if value == nil then
        return nil
    end
    return M.keys(value)
end

---@param value any
---@return keymap.Action
function M.action(value)
    vim.validate("value", value, { "string", "function" })
    return value
end

---@param value any
---@return keymap.Action | nil
function M.action_nillable(value)
    if value == nil then
        return nil
    end
    return M.action(value)
end

---@param value any
---@return keymap.BufferSet
function M.buffer_set(value)
    vim.validate("value", value, "table")
    return value
end

---@param value any
---@return keymap.Condition
function M.condition(value)
    vim.validate("value", value, "table")
    return value
end

---@param value any
---@return keymap.KeymapOptions
function M.options(value)
    vim.validate("value", value, "table")
    vim.validate("remap", value.remap, "boolean", true)
    vim.validate("nowait", value.nowait, "boolean", true)
    vim.validate("silent", value.silent, "boolean", true)
    vim.validate("desc", value.desc, "string", true)
    vim.validate("expr", value.expr, "boolean", true)
    vim.validate("unique", value.unique, "boolean", true)
    vim.validate("replace_keycodes", value.replace_keycodes, "boolean", true)

    return {
        remap = value.remap,
        nowait = value.nowait,
        silent = value.silent,
        desc = value.desc,
        expr = value.expr,
        unique = value.unique,
        replace_keycodes = value.replace_keycodes,
    }
end

return M
