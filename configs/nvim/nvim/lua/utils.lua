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

M.requires = function(requires, f)
    local args = {}
    for i, name in ipairs(requires) do
        result, module = pcall(require, name)
        if not result then
            return
        end
        args[i] = module
    end
    return f(unpack(args))
end

return M
