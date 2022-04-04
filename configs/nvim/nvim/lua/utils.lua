local M = {}

M.require_conf = function(name)
    return [[require'plugins.]] .. name .. "'"
end

_G.put = function(value)
    print(vim.inspect(value))
end

M.require_all = function(...)
    local args = {}
    for i, name in ipairs({...}) do
        local result, module = pcall(require, name)
        if not result then
            if vim.g.debug then
                vim.notify('[Warning] Cannot load module "' .. name ..  '".', 3)
                print(debug.traceback())
            end
            return function(_) return nil end
        end
        args[i] = module
    end

    return function(f)
        return f(unpack(args))
    end
end

return M
