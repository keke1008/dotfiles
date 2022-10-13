---@class Rect
---@field col number
---@field row number
---@field width number
---@field height number

local M = {}

local function layout()
    local editor_width = vim.go.columns
    local editor_height = vim.go.lines

    local container_row = math.floor(editor_height * 0.1)
    local container_col = math.floor(editor_width * 0.1)
    local container_width = editor_width - 2 * container_col
    local container_height = editor_height - 3 * container_row

    local filer = {
        row = container_row,
        col = container_col,
        width = math.min(50, math.floor(container_width * 0.3)),
        height = container_height,
        border = "single"
    }

    local previewer = {
        col = container_col + filer.width + 2,
        row = container_row,
        width = container_width - filer.width,
        height = container_height,
    }

    local rename_width = math.floor(editor_width / 2)
    local rename_height = math.floor(editor_height / 2)

    local rename = {
        col = math.floor(rename_width / 2),
        row = math.floor(rename_height / 2),
        width = rename_width,
        height = rename_height,
    }

    return {
        filer = filer,
        previewer = previewer,
        rename = rename,
    }
end

---@param rect Rect
---@return number winid
local function open_window_from_rect(rect)
    local config = {
        row = rect.row,
        col = rect.col,
        width = rect.width,
        height = rect.height,
        relative = "editor",
        border = "single",
        focusable = true,
        style = "minimal",
        noautocmd = true,
    }
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")

    local winid = vim.api.nvim_open_win(bufnr, false, config)
    vim.api.nvim_win_set_option(winid, "winblend", 30)

    return winid
end

---@return number winid
function M.fern()
    local rect = layout().filer
    return open_window_from_rect(rect)
end

---@return number winid
function M.preview()
    local rect = layout().previewer
    return open_window_from_rect(rect)

end

---@return number winid
function M.rename()
    local rect = layout().rename
    return open_window_from_rect(rect)
end

return M
