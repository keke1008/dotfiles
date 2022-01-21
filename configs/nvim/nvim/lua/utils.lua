local M = {}

M.esc = function(cmd)
    return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

return M
