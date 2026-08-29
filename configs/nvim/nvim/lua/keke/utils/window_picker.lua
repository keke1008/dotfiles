local DeferredStack = require("keke.utils.deferred_stack")

local M = {}

---@param winid integer
---@return boolean
local function is_pickable_window(winid)
    local cfg = vim.api.nvim_win_get_config(winid)
    if cfg.relative ~= "" then
        return false
    end

    local bufid = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufid })
    if buftype == "quickfix" or buftype == "prompt" then
        return false
    end

    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufid })
    if filetype == "netrw" then
        return false
    end

    return true
end

---@param winid integer
---@param label string
---@return function cleanup
local function show_label(winid, label)
    local win_width = vim.api.nvim_win_get_width(winid)
    local label_spaces = math.floor((win_width - #label) / 2)
    local label_line = (" "):rep(label_spaces) .. label:upper()

    local bufid = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufid, 0, -1, false, { label_line })
    local label_winid = vim.api.nvim_open_win(bufid, false, {
        relative = "win",
        win = winid,
        anchor = "SW",
        fixed = true,
        row = vim.api.nvim_win_get_height(winid),
        col = 0,
        width = win_width,
        height = 1,
        style = "minimal",
        border = "none",
        zindex = 999,
        focusable = false,
        noautocmd = true,
    })
    vim.api.nvim_set_option_value("winhl", "Normal:IncSearch", { win = label_winid })

    return function()
        pcall(vim.api.nvim_win_close, label_winid, true)
        pcall(vim.api.nvim_buf_delete, bufid, { force = true })
    end
end

---@param winids integer[]
---@return true ok
---@return integer winid
---@overload fun(winids: integer[]): false, nil
local function prompt_label_input(winids)
    local cleanup_labels = DeferredStack.new()

    local ok_show_label, err = pcall(function()
        for i, winid in ipairs(winids) do
            local label = string.char(("a"):byte() + i - 1)
            cleanup_labels:push(show_label(winid, label))
        end
        vim.cmd("redraw")
    end)
    if not ok_show_label then
        cleanup_labels:run()
        vim.notify(tostring(err), vim.log.levels.ERROR)
        return false, nil
    end

    local ok_getchar, ch = pcall(vim.fn.getcharstr)
    cleanup_labels:run()
    if not ok_getchar then
        return false, nil
    end

    local idx = ch:byte() - ("a"):byte() + 1
    if 1 <= idx and idx <= #winids then
        return true, winids[idx]
    else
        return false, nil
    end
end

---@return true ok
---@return integer winid
---@overload fun(): false, nil
function M.pick_window()
    local winids = vim.api.nvim_tabpage_list_wins(0)
    local pickable_winids = vim.iter(winids):filter(is_pickable_window):totable()
    if #pickable_winids == 0 then
        return true, nil
    end
    if #pickable_winids == 1 then
        return true, pickable_winids[1]
    end

    return prompt_label_input(pickable_winids)
end

return M
