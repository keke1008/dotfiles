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

return M
