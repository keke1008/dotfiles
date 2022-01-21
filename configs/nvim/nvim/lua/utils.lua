local M = {}

M.esc = function(cmd)
    return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

M.require_conf = function(name)
    return [[require'plugins.config.]] .. name
end

return M
