local M = {}

---@return number bufnr
function M.create_scratch_buffer()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
    return bufnr
end

---@param rect Rect
function M.open_window(rect)
    local bufnr = M.create_scratch_buffer()
    local config = {
        relative = "editor",
        col = rect.col,
        row = rect.row,
        width = rect.width,
        height = rect.height,
        border = "single",
        focusable = false,
        style = "minimal",
        noautocmd = true,
    }
    local winid = vim.api.nvim_open_win(bufnr, false, config)
    vim.api.nvim_win_set_option(winid, "winblend", 30)
    return winid
end

return M
