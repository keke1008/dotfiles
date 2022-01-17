local M = {}

M.esc = function(cmd)
    return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

M.get_cursor_char = function(offset)
    local col = vim.fn.col('.') + (offset or 0)
    return vim.api.nvim_get_current_line():sub(col, col)
end

M.pumvisible = function()
    return vim.fn.pumvisible() == 1
end

return M
