local M = {}

M.esc = function(cmd)
    return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

M.require_conf = function(name)
    return [[require'plugins.config.]] .. name .. "'"
end

local function put_inner(key, value, depth)
    local tab = string.rep(' ', depth * 4)
    local prefix = tab .. (key and key .. ' = ' or '')

    if type(value) ~= 'table' then
        return prefix .. tostring(value)
    end
    if next(value) == nil then -- If table is empty
        return prefix .. '{}\n'
    end

    local result = prefix .. '{\n'
    for k, v in pairs(value) do
        result = result .. put_inner(k, v, depth + 1) .. '\n'
    end
    return result .. tab .. '}\n'
end

_G.put = function(value)
    print(put_inner(nil, value, 0))
end

return M
