local M = {}

---@class RemapOptions
---@field buffer? boolean
---@field nowait? boolean
---@field silent? boolean
---@field script? boolean
---@field expr?   boolean
---@field unique? boolean

M.feedkeys = function(keys)
    keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
    ---@cast keys string
    vim.api.nvim_feedkeys(keys, 'int', false)
end

---@param keys string
M.feedkeys_recursive = function(keys)
    keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
    ---@cast keys string
    vim.api.nvim_feedkeys(keys, 'i', false)
end

---@param mode string
---@param lhs string
---@param rhs function|string
---@param opt RemapOptions
M.fallback = function(mode, lhs, rhs, opt)
    vim.keymap.del(mode, lhs, { buffer = opt.buffer == true })
    M.feedkeys_recursive(lhs)

    vim.schedule(function()
        vim.keymap.set(mode, lhs, rhs, opt)
    end)
end

---@param mode string
---@param lhs string
---@param rhs function|string
---@param opt? RemapOptions
M.set_keymap = function(mode, lhs, rhs, opt)
    for i = 1, #mode do
        vim.keymap.set(mode:sub(i, i), lhs, rhs, opt)
    end
end

return M
