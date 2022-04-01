local M = {}

M.esc = function(cmd)
    return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

M.require_conf = function(name)
    return [[require'plugins.config.]] .. name .. "'"
end

_G.put = function(value)
    print(vim.inspect(value))
end

M.no_vscode = function()
    return vim.fn.exists'g:vscode' == 0
end

M.require_all = function(...)
    local args = {}
    for i, name in ipairs({...}) do
        local result, module = pcall(require, name)
        if not result then
            vim.notify('[Warning] Cannot load module "' .. name ..  '".', 3)
            print(debug.traceback())
            return function(_) return nil end
        end
        args[i] = module
    end

    return function(f)
        return f(unpack(args))
    end
end

return M
