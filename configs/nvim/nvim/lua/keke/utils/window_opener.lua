local M = {}

local window_picker = require("keke.utils.window_picker")

---@generic T
---@param with fun(): T
---@return T
local function with_preserve_netrw_width(with)
    local netrw_winid = vim.iter(vim.api.nvim_tabpage_list_wins(0)):find(function(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        return vim.api.nvim_get_option_value("filetype", { buf = bufid }) == "netrw"
    end)

    if netrw_winid == nil then
        return with()
    end

    local netrw_width = vim.api.nvim_win_get_width(netrw_winid)
    local equalalways = vim.o.equalalways
    vim.o.equalalways = false

    local result = with()

    vim.o.equalalways = equalalways
    vim.api.nvim_win_set_width(netrw_winid, netrw_width)

    return result
end

---@param filepath string
---@param with fun(winid: integer, bufid: integer): integer
---@return integer | nil winid
local function open_file_in_window_with(filepath, with)
    local ok_winid, winid = window_picker.pick_window()
    if not ok_winid then
        return nil
    end

    local bufid = vim.fn.bufadd(filepath)
    return with_preserve_netrw_width(function()
        if winid == nil then
            return vim.api.nvim_open_win(bufid, true, { split = "right", win = -1 })
        else
            return with(winid, bufid)
        end
    end)
end

---@param filepath string
---@return integer | nil winid
function M.open_file(filepath)
    return open_file_in_window_with(filepath, function(winid, bufid)
        vim.api.nvim_win_set_buf(winid, bufid)
        vim.api.nvim_set_current_win(winid)
        return winid
    end)
end

---@param filepath string
---@return integer | nil winid
function M.open_file_with_splitting_window(filepath)
    return open_file_in_window_with(filepath, function(winid, bufid)
        return vim.api.nvim_open_win(bufid, true, { split = "above", win = winid })
    end)
end

---@param filepath string
---@return integer | nil winid
function M.open_file_with_vsplitting_window(filepath)
    return open_file_in_window_with(filepath, function(winid, bufid)
        return vim.api.nvim_open_win(bufid, true, { split = "left", win = winid })
    end)
end

return M
