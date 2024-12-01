local M = {}

local second_leader = "\\"

-- second leader key
---@param key string
---@return string
function M.l2(key)
    return second_leader .. key
end

---@param opts table
---@param desc string
---@return table
function M.add_desc(opts, desc)
    local new_opts = {}
    for key, value in pairs(opts) do
        new_opts[key] = value
    end
    new_opts.desc = desc

    return new_opts
end

---@param key string
---@param name string
---@param buffer? number
function M.add_group(key, name, buffer)
    local wk = vim.F.npcall(require, "which-key")
    if not wk then
        return
    end
    wk.register({ [key] = { name = name } }, { buffer = buffer })
end

return M
